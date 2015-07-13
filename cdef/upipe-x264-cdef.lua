local ffi = require "ffi"
ffi.cdef [[
struct upipe_mgr *upipe_x264_mgr_alloc(void);
bool upipe_x264_reconfigure(struct upipe *);
bool upipe_x264_set_default(struct upipe *);
bool upipe_x264_set_default_mpeg2(struct upipe *);
bool upipe_x264_set_default_preset(struct upipe *, char const *, char const *);
bool upipe_x264_set_profile(struct upipe *, char const *);
bool upipe_x264_set_sc_latency(struct upipe *, uint64_t);
]]
libupipe_x264 = ffi.load("libupipe_x264.so", true)
libupipe_x264_static = ffi.load("libupipe-x264.static.so", true)
