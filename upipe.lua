local ffi = require "ffi"
local va_args = require "ffi-stdarg"
local fmt = string.format
local C = ffi.C

ffi.cdef [[
    // stdlib.h
    typedef long ssize_t;
    void *malloc(size_t);
    void free(void *);

    // stdio.h
    typedef struct _IO_FILE FILE;

    // time.h
    typedef long time_t;
]]

require "upipe-cdef"
require "upipe-modules-cdef"
require "upipe-framers-cdef"
require "upipe-ts-cdef"
require "upipe-av-cdef"
require "upipe-filters-cdef"
require "upipe-swscale-cdef"
require "upipe-x264-cdef"
require "upump-ev-cdef"

UCLOCK_FREQ = 27000000

setmetatable(_G, { __index = C })

local props = { }
local cbref = { }

local init = {
    upipe_mgr = function (mgr, cb)
	mgr.upipe_alloc = cb.alloc or
	    function (mgr, probe, signature, args)
		local pipe = upipe_alloc(mgr, probe)
		if cb.init then cb.init(pipe) end
		pipe.props.clean = cb.clean
		return C.upipe_use(pipe)
	    end
	mgr.upipe_input = cb.input
	mgr.upipe_control = cb.control
    end,

    uclock = function (clock, now, mktime)
	clock.uclock_now = now
	clock.uclock_mktime = mktime
    end
}

local function alloc(ty)
    local st = ffi.typeof("struct " .. ty)
    local ct = ffi.typeof("struct { struct urefcount refcount; $ data; }", st)
    local cb = ffi.cast("urefcount_cb", function (refcount)
	local data = ffi.cast(ffi.typeof("$ *", st),
	    ffi.cast("char *", refcount) + ffi.offsetof(ct, "data"))
	if ty == "upipe" or ty == "uclock" then
	    local k = tostring(data):match(": 0x(.*)")
	    if props[k] and props[k].clean then props[k].clean(data) end
	    props[k] = nil
	end
	if ty ~= "upipe_mgr" then C[ty .. "_clean"](data) end
	if cbref[tostring(refcount)] then
	    cbref[tostring(refcount)]:free()
	    cbref[tostring(refcount)] = nil
	end
	C.free(ffi.cast("void *", refcount))
    end)
    return function (...)
	local cd = ffi.cast(ffi.typeof("$ *", ct), C.malloc(ffi.sizeof(ct)))
	local args = { ... }
	for i, arg in ipairs(args) do
	    if ffi.istype("struct uprobe", arg) then
		args[i] = C.uprobe_use(arg)
	    end
	end
	(init[ty] or C[ty .. "_init"])(cd.data, unpack(args))
	C.urefcount_init(cd.refcount, cb)
	cd.data.refcount = cd.refcount
	if ty == 'uprobe' then
	    args[1] = ffi.cast("uprobe_throw_func", args[1])
	    cbref[tostring(cd.data.refcount)] = args[1]
	end
	return ffi.gc(cd.data, C[ty .. "_release"])
    end
end

uprobe_alloc = alloc "uprobe"
upipe_alloc = alloc "upipe"
uclock_alloc = alloc "uclock"

local mgr_alias = {
    umem = {
	pool_simple = { "pool", "simple" }
    }
}

local mgr_mt = {
    __index = function (ctx, key)
	local sym_alloc = fmt("%s_%s_mgr_alloc", ctx.name, key)
	local sym_release = fmt("%s_mgr_release", ctx.name)
	local alias = (mgr_alias[ctx.name] or { })[key]
	if alias then
	    sym_alloc = fmt("%s_%s_mgr_alloc_%s", ctx.name, alias[1], alias[2])
	end
	return function (...)
	    return ffi.gc(C[sym_alloc](...), C[sym_release])
	end
    end
}

for _, name in ipairs { 'upump', 'udict', 'uref', 'umem', 'ubuf' } do
    _G[name] = setmetatable({ name = name }, mgr_mt)
end

local probe_args = require "uprobe-args"

local function get_probe_args(args, args_list)
    if not args_list then return args end
    return va_args(args, unpack(args_list))
end

local function ubase_err(ret)
    return type(ret) == "string" and C["UBASE_ERR_" .. ret:upper()] or ret or C.UBASE_ERR_NONE
end

uprobe = setmetatable({ }, {
    __call = function (_, uprobe_throw)
	if type(uprobe_throw) ~= 'function' then
	    local events = { }
	    for k, v in pairs(uprobe_throw) do
		local k = k:upper()
		events[C[fmt("UPROBE_%s", k)]] = { func = v, args = probe_args[k] }
	    end
	    uprobe_throw = function (probe, pipe, event, args)
		local e = events[event]
		if e then
		    if event >= C.UPROBE_LOCAL then
			local signature = va_args(args, "uint32_t")
			if signature ~= pipe.mgr.signature then
			    return C.UBASE_ERR_UNHANDLED
			end
		    end
		    return ubase_err(e.func(probe, pipe, get_probe_args(args, e.args)))
		else
		    return probe:throw_next(pipe, event, args)
		end
	    end
	end
	return uprobe_alloc(uprobe_throw, ffi.cast("struct uprobe *", nil))
    end,
    __index = function (_, key)
	local sym = fmt("uprobe_%s_alloc", key)
	return function (...)
	    local args = { ... }
	    for i, arg in ipairs(args) do
		if ffi.istype("struct uprobe", arg) then
		    args[i] = C.uprobe_use(arg)
		end
	    end
	    if key == 'selflow' then
		table.insert(args, 1, args[3])
		table.remove(args, 4)
	    end
	    return ffi.gc(C[sym](nil, unpack(args)), C.uprobe_release)
	end
    end
})

uclock = setmetatable({ }, {
    __index = function (_, key)
	return function (...)
	    return ffi.gc(C[fmt("uclock_%s_alloc", key)](...), C.uclock_release)
	end
    end
})

local upipe_getters = require "upipe-getters"
local uref_getters = require "uref-getters"

local function getter(getters, f, key)
    if getters[key] then
	return function (self, arg)
	    if arg ~= nil then return f(self, arg) end
	    local arg_p = ffi.new(getters[key] .. "[1]")
	    local ret = f(self, arg_p)
	    if not C.ubase_check(ret) then
		return nil, ret
	    end
	    return arg_p[0]
	end
    end
end

local function fourcc(n1, n2, n3, n4)
    n1 = type(n1) == 'string' and n1:byte(1) or n1
    n2 = type(n2) == 'string' and n2:byte(1) or n2
    n3 = type(n3) == 'string' and n3:byte(1) or n3
    n4 = type(n4) == 'string' and n4:byte(1) or n4
    return n4*2^24 + n3*2^16 + n2*2^8 + n1
end

local sigs = { }
function upipe_sig(name, n1, n2, n3, n4)
    sigs[fourcc(n1, n2, n3, n4)] = name
end

require "upipe-modules-sigs"
require "upipe-ts-sigs"
require "upipe-av-sigs"
require "upipe-filters-sigs"
require "upipe-framers-sigs"
require "upipe-x264-sigs"
upipe_sig = nil

local sig = {
    void = fourcc('v','o','i','d'),
    flow = fourcc('f','l','o','w'),
}

ffi.metatype("struct upipe_mgr", {
    __index = function (mgr, key)
	if key == 'new' then key = 'new_void' end
	local mgr_sig = key:match("^new_(.*)")
	if mgr_sig then
	    return function (mgr, probe, ...)
		local pipe = C.upipe_alloc(mgr, C.uprobe_use(probe), sig[mgr_sig] or 0, ...)
		assert(pipe ~= nil, "upipe_alloc failed")
		return ffi.gc(pipe, C.upipe_release)
	    end
	end
	return C[fmt("upipe_%s_mgr_%s", sigs[mgr.signature], key)]
    end,
    __newindex = function (mgr, key, val)
	local sym = fmt("upipe_%s_mgr_set_%s", sigs[mgr.signature], key)
	C[sym](mgr, val)
    end
})

local function iterator(pipe, f, t)
    local item_p = ffi.new(t .. "[1]")
    return function ()
	assert(ubase_check(f(pipe, item_p)))
	return item_p[0] ~= nil and item_p[0] or nil
    end
end

ffi.metatype("struct upipe", {
    __index = function (pipe, key)
	if key == 'new' then
	    return function (pipe, probe)
		return ffi.gc(C.upipe_void_alloc_sub(pipe, uprobe_use(probe)), C.upipe_release)
	    end
	elseif key == 'props' then
	    local k = tostring(pipe):match(": 0x(.*)")
	    if not props[k] then props[k] = { } end
	    return props[k]
	elseif key == 'release' then
	    return function (pipe)
		ffi.gc(pipe, nil)
		C.upipe_release(pipe)
	    end
	elseif key == 'iterate_sub' then
	    return function (pipe, p)
		local f = C.upipe_iterate_sub
		return p and f(pipe, p) or iterator(pipe, f, "struct upipe *")
	    end
	elseif key == 'split_iterate' then
	    return function (pipe, p)
		local f = C.upipe_split_iterate
		return p and f(pipe, p) or iterator(pipe, f, "struct uref *")
	    end
	elseif key == 'iterate' then
	    return function (pipe, f, t)
		if type(f) == 'string' then f = pipe[f] end
		return iterator(pipe, f, t)
	    end
	end
	local f =  C[fmt("upipe_%s", key)]
	return getter(upipe_getters, f, key) or f
    end,
    __newindex = function (pipe, key, val)
	local sym = fmt("upipe_set_%s", key)
	assert(C.ubase_check(C[sym](pipe, val)), sym)
    end,
    __concat = function (pipe, next_pipe)
        local last = pipe
        local output = ffi.new("struct upipe *[1]")
	while C.ubase_check(last:get_output(output)) and output[0] ~= nil do
	    last = output[0]
	end
        last.output = next_pipe
        return pipe
    end,
})

ffi.metatype("struct uref", {
    __index = function (_, key)
	local f = C[fmt("uref_%s", key)]
	return getter(uref_getters, f, key) or f
    end
})

ffi.metatype("struct ubuf", {
    __index = function (_, key)
	return C[fmt("ubuf_%s", key)]
    end
})

ffi.metatype("struct upump", {
    __index = function (_, key)
	return C[fmt("upump_%s", key)]
    end
})

ffi.metatype("struct urefcount", {
    __index = function (_, key)
	return C[fmt("urefcount_%s", key)]
    end
})

ffi.metatype("struct uprobe", {
    __index = function (_, key)
	return C[fmt("uprobe_%s", key)]
    end,
    __concat = function (probe, next_probe)
	local last = probe
	while last.next ~= nil do last = last.next end
	last.next = C.uprobe_use(next_probe)
	return probe
    end
})

ffi.metatype("struct uclock", {
    __index = function (_, key)
	if key == 'props' then
	    local k = tostring(pipe):match(": 0x(.*)")
	    if not props[k] then props[k] = { } end
	    return props[k]
	end
	return C[fmt("uclock_%s", key)]
    end
})

return setmetatable({
    name = "upipe",
    sigs = sigs,
    mgr = alloc("upipe_mgr"),
    iterator = iterator
}, mgr_mt)
