local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_filter_blend_mgr_alloc(void);
struct upipe_mgr *upipe_fdec_mgr_alloc(void);
struct upipe_mgr *upipe_fenc_mgr_alloc(void);
struct upipe_mgr *upipe_ffmt_mgr_alloc(void);
struct upipe_mgr *upipe_filter_ebur128_mgr_alloc(void);
int upipe_fdec_mgr_get_avcdec_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_fdec_mgr_set_avcdec_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_fenc_mgr_get_avcenc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_fenc_mgr_set_avcenc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_fenc_mgr_get_x264_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_fenc_mgr_set_x264_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_get_sws_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_set_sws_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_get_swr_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_set_swr_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_get_deint_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ffmt_mgr_set_deint_mgr(struct upipe_mgr *, struct upipe_mgr *);
]]
libupipe_filters = ffi.load("libupipe_filters.so.0", true)
libupipe_filters_static = ffi.load("libupipe-filters.static.so", true)
