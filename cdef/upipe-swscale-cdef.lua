local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_sws_mgr_alloc(void);
struct upipe_mgr *upipe_sws_thumbs_mgr_alloc(void);
bool upipe_sws_get_flags(struct upipe *, int *);
bool upipe_sws_set_flags(struct upipe *, int);
bool upipe_sws_thumbs_set_size(struct upipe *, int, int, int, int);
bool upipe_sws_thumbs_get_size(struct upipe *, int *, int *, int *, int *);
bool upipe_sws_thumbs_flush_next(struct upipe *);
]]
libupipe_sws = ffi.load("libupipe_sws.so.0", true)
libupipe_swscale_static = ffi.load("libupipe-swscale.static.so", true)
