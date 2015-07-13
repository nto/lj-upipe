require "upipe-cdef"
require "upipe-modules-cdef"
require "upipe-framers-cdef"
require "upipe-ts-cdef"
require "upipe-av-cdef"
require "upipe-filters-cdef"
require "upipe-swscale-cdef"
require "upipe-x264-cdef"
require "upump-ev-cdef"

local ffi = require "ffi"
local fmt = string.format
local C = ffi.C

-- stdlib.h
ffi.cdef [[
    void *malloc(size_t);
    void free(void *);
]]

-- upipe.h
ffi.cdef [[
    enum upipe_command {
	UPIPE_ATTACH_UREF_MGR,
	UPIPE_ATTACH_UPUMP_MGR,
	UPIPE_ATTACH_UCLOCK,
	UPIPE_GET_URI,
	UPIPE_SET_URI,
	UPIPE_GET_OPTION,
	UPIPE_SET_OPTION,
	UPIPE_REGISTER_REQUEST,
	UPIPE_UNREGISTER_REQUEST,
	UPIPE_SET_FLOW_DEF,
	UPIPE_GET_MAX_LENGTH,
	UPIPE_SET_MAX_LENGTH,
	UPIPE_FLUSH,
	UPIPE_GET_OUTPUT,
	UPIPE_SET_OUTPUT,
	UPIPE_ATTACH_UBUF_MGR,
	UPIPE_GET_FLOW_DEF,
	UPIPE_GET_OUTPUT_SIZE,
	UPIPE_SET_OUTPUT_SIZE,
	UPIPE_SPLIT_ITERATE,
	UPIPE_GET_SUB_MGR,
	UPIPE_ITERATE_SUB,
	UPIPE_SUB_GET_SUPER,
	UPIPE_CONTROL_LOCAL = 0x8000
    };
]]

-- uref.h
ffi.cdef [[
    enum uref_date_type {
	UREF_DATE_NONE = 0,
	UREF_DATE_CR = 1,
	UREF_DATE_DTS = 2,
	UREF_DATE_PTS = 3
    };
]]

-- uprobe.h
ffi.cdef [[
    enum uprobe_event {
	UPROBE_LOG,
	UPROBE_FATAL,
	UPROBE_ERROR,
	UPROBE_READY,
	UPROBE_DEAD,
	UPROBE_SOURCE_END,
	UPROBE_SINK_END,
	UPROBE_NEED_OUTPUT,
	UPROBE_PROVIDE_REQUEST,
	UPROBE_NEED_UPUMP_MGR,
	UPROBE_FREEZE_UPUMP_MGR,
	UPROBE_THAW_UPUMP_MGR,
	UPROBE_NEW_FLOW_DEF,
	UPROBE_NEW_RAP,
	UPROBE_SPLIT_UPDATE,
	UPROBE_SYNC_ACQUIRED,
	UPROBE_SYNC_LOST,
	UPROBE_CLOCK_REF,
	UPROBE_CLOCK_TS,
	UPROBE_CLOCK_UTC,
	UPROBE_LOCAL = 0x8000
    };
]]

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
		return C.upipe_use(pipe)
	    end
	mgr.upipe_input = cb.input
	mgr.upipe_control = cb.control
    end
}

local function alloc(ty)
    local st = ffi.typeof("struct " .. ty)
    local ct = ffi.typeof("struct { struct urefcount refcount; $ data; }", st)
    local cb = ffi.cast("urefcount_cb", function (refcount)
	local data = ffi.cast(ffi.typeof("$ *", st),
	    ffi.cast("char *", refcount) + ffi.offsetof(ct, "data"))
	if ty ~= "upipe_mgr" then C[ty .. "_clean"](data) end
	if cbref[tostring(refcount)] then
	    cbref[tostring(refcount)]:free()
	    cbref[tostring(refcount)] = nil
	end
	if ty == "upipe" then
	    local k = tostring(data):match(": 0x(.*)")
	    props[k] = nil
	end
	C.free(ffi.cast("void *", refcount))
    end)
    return function (...)
	local cd = ffi.cast(ffi.typeof("$ *", ct), malloc(ffi.sizeof(ct)))
	local args = { ... }
	for i, arg in ipairs(args) do
	    if ffi.istype("struct uprobe", arg) then
		args[i] = uprobe_use(arg)
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

_G.uprobe = setmetatable({ }, {
    __call = function (_, uprobe_throw)
	if type(uprobe_throw) ~= 'function' then
	    local probe_events = { }
	    for k, v in pairs(uprobe_throw) do
		probe_events[C[fmt("UPROBE_%s", k)]] = v
	    end
	    uprobe_throw = function (probe, pipe, event, args)
		if probe_events[event] then
		    return probe_events[event](probe, pipe, args) or C.UBASE_ERR_NONE
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

local sigs = { }
function upipe_sig(name, n1, n2, n3, n4)
    n1 = type(n1) == 'string' and n1:byte(1) or n1
    n2 = type(n2) == 'string' and n2:byte(1) or n2
    n3 = type(n3) == 'string' and n3:byte(1) or n3
    n4 = type(n4) == 'string' and n4:byte(1) or n4
    sigs[n4*2^24 + n3*2^16 + n2*2^8 + n1] = name
end

require "upipe-modules_sig"
require "upipe-ts_sig"
require "upipe-av_sig"
require "upipe-filters_sig"
require "upipe-x264_sig"
upipe_sig = nil

ffi.metatype("struct upipe_mgr", {
    __index = {
	new = function (mgr, probe)
	    return ffi.gc(C.upipe_void_alloc(mgr, uprobe_use(probe)), C.upipe_release)
	end,
	new_flow = function (mgr, probe, flow)
	    return ffi.gc(C.upipe_flow_alloc(mgr, uprobe_use(probe), flow), C.upipe_release)
	end
    },
    __newindex = function (mgr, key, val)
	local sym = fmt("upipe_%s_mgr_set_%s", sigs[mgr.signature], key)
	C[sym](mgr, val)
    end
})

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
	end
	return C[fmt("upipe_%s", key)]
    end,
    __newindex = function (pipe, key, val)
	local sym = fmt("upipe_set_%s", key)
	assert(C.ubase_check(C[sym](pipe, val)), sym)
    end,
    __concat = function (pipe, next_pipe)
        local last = pipe
        local output = ffi.new("struct upipe *[1]")
        while true do
            if not C.ubase_check(last:get_output(output)) then break end
            if output[0] == nil then break end
            last = output[0]
        end
        last.output = next_pipe
        return pipe
    end,
})

ffi.metatype("struct uref", {
    __index = function (_, key)
	return C[fmt("uref_%s", key)]
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

return setmetatable({
    name = "upipe",
    sigs = sigs,
    mgr = alloc("upipe_mgr")
}, mgr_mt)
