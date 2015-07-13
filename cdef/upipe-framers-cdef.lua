local ffi = require "ffi"
ffi.cdef [[
uint8_t const *upipe_framers_mpeg_scan(uint8_t const *, uint8_t const *, uint32_t *);
struct upipe_mgr *upipe_h264f_mgr_alloc(void);
struct upipe_mgr *upipe_mpgvf_mgr_alloc(void);
struct upipe_mgr *upipe_a52f_mgr_alloc(void);
struct upipe_mgr *upipe_opusf_mgr_alloc(void);
struct upipe_mgr *upipe_mpgaf_mgr_alloc(void);
struct upipe_mgr *upipe_telxf_mgr_alloc(void);
struct upipe_mgr *upipe_dvbsubf_mgr_alloc(void);
struct upipe_mgr *upipe_vtrim_mgr_alloc(void);
]]
libupipe_framers = ffi.load("libupipe_framers.so", true)
