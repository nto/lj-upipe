local ffi = require("ffi")
ffi.cdef [[
typedef struct upump_mgr *(*upipe_pthread_upump_mgr_alloc)(void);
typedef void (*upipe_pthread_upump_mgr_work)(struct upump_mgr *);
typedef void (*upipe_pthread_upump_mgr_free)(struct upump_mgr *);
struct upipe_mgr *upipe_pthread_xfer_mgr_alloc(uint8_t, uint16_t, struct uprobe *, upipe_pthread_upump_mgr_alloc, upipe_pthread_upump_mgr_work, upipe_pthread_upump_mgr_free, pthread_t *, pthread_attr_t const *);
]]
libupipe_pthread = ffi.load("libupipe_pthread.so.0", true)
libupipe_pthread_static = ffi.load("libupipe-pthread.static.so", true)
