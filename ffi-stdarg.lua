local ffi = require "ffi"
local stdarg = ffi.load("ffi-stdarg")

ffi.cdef [[
    intptr_t ffi_va_arg(va_list *ap, const char *type);
]]

local is_number = {
    int = true,
    ["unsigned int"] = true,
    ["signed int"] = true,
    uint32_t = true,
}

return function (va_list, ...)
    if ffi.arch == "arm" then
	va_list = ffi.new("void *[1]", va_list)
    end

    local ret = { }
    local n = select("#", ...)
    for i = 1, n do
	local ty = select(i, ...)
	local val = stdarg.ffi_va_arg(va_list, ty)
	if is_number[ty] then
	    ret[i] = tonumber(val)
	elseif ty == "const char *" then
	    ret[i] = val ~= 0 and ffi.string(ffi.cast("const char *", val)) or nil
	else
	    ret[i] = ffi.cast(select(i, ...), val)
	end
    end
    return unpack(ret)
end
