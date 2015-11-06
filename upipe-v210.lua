local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_v210enc_mgr_alloc(void);
typedef void (*upipe_v210enc_pack_line_8)(uint8_t const *, uint8_t const *, uint8_t const *, uint8_t *, ptrdiff_t);
int upipe_v210enc_set_pack_line_8(struct upipe *, upipe_v210enc_pack_line_8);
int upipe_v210enc_get_pack_line_8(struct upipe *, upipe_v210enc_pack_line_8 *);
typedef void (*upipe_v210enc_pack_line_10)(uint16_t const *, uint16_t const *, uint16_t const *, uint8_t *, ptrdiff_t);
int upipe_v210enc_set_pack_line_10(struct upipe *, upipe_v210enc_pack_line_10);
int upipe_v210enc_get_pack_line_10(struct upipe *, upipe_v210enc_pack_line_10 *);
]]
libupipe_v210 = ffi.load("libupipe_v210.so.0", true)
libupipe_v210_static = ffi.load("libupipe-v210.static.so", true)
