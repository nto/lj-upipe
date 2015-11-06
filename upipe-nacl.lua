local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_nacl_g2d_mgr_alloc(void);
struct upipe_mgr *upipe_nacl_audio_mgr_alloc(void);
]]
libupipe_nacl = ffi.load("libupipe_nacl.so.0", true)
libupipe_nacl_static = ffi.load("libupipe-nacl.static.so", true)
