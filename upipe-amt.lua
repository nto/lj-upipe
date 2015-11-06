local ffi = require("ffi")
ffi.cdef [[
struct upipe_mgr *upipe_amtsrc_mgr_alloc(char const *);
int upipe_amtsrc_mgr_set_timeout(struct upipe_mgr *, unsigned int);
]]
libupipe_amt = ffi.load("libupipe_amt.so.0", true)
libupipe_amt_static = ffi.load("libupipe-amt.static.so", true)
