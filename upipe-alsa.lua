local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_alsink_mgr_alloc(void);
struct upipe_mgr *upipe_alsource_mgr_alloc(void);
]]
libupipe_alsa = ffi.load("libupipe_alsa.so.0", true)
libupipe_alsa_static = ffi.load("libupipe-alsa.static.so", true)
