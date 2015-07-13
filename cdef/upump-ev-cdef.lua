local ffi = require "ffi"
ffi.cdef [[
struct ev_loop;
struct upump_mgr *upump_ev_mgr_alloc(struct ev_loop *, uint16_t, uint16_t);
]]
libupump_ev = ffi.load("libupump_ev.so", true)
