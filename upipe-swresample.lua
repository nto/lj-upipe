local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_swr_mgr_alloc(void);
]]
libupipe_swresample = ffi.load("libupipe_swresample.so.0", true)
libupipe_swresample_static = ffi.load("libupipe-swresample.static.so", true)
