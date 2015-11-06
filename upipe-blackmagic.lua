local ffi = require("ffi")
ffi.cdef [[
void upipe_bmd_src_work(struct upipe *, struct upump *);
struct upipe_mgr *upipe_bmd_src_mgr_alloc(void);
int upipe_bmd_src_get_pic_sub(struct upipe *, struct upipe **);
int upipe_bmd_src_get_sound_sub(struct upipe *, struct upipe **);
int upipe_bmd_src_get_subpic_sub(struct upipe *, struct upipe **);
]]
libupipe_blackmagic = ffi.load("libupipe_blackmagic.so.0", true)
libupipe_blackmagic_static = ffi.load("libupipe-blackmagic.static.so", true)
