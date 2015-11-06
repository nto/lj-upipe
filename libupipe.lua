local ffi = require("ffi")
ffi.cdef [[
enum ubase_err {
	UBASE_ERR_NONE,
	UBASE_ERR_UNKNOWN,
	UBASE_ERR_ALLOC,
	UBASE_ERR_NOSPC,
	UBASE_ERR_UPUMP,
	UBASE_ERR_UNHANDLED,
	UBASE_ERR_INVALID,
	UBASE_ERR_EXTERNAL,
	UBASE_ERR_BUSY,
	UBASE_ERR_LOCAL = 32768,
};
enum uref_date_type {
	UREF_DATE_NONE,
	UREF_DATE_CR,
	UREF_DATE_DTS,
	UREF_DATE_PTS,
};
enum uprobe_event {
	UPROBE_LOG,
	UPROBE_FATAL,
	UPROBE_ERROR,
	UPROBE_READY,
	UPROBE_DEAD,
	UPROBE_SOURCE_END,
	UPROBE_SINK_END,
	UPROBE_NEED_OUTPUT,
	UPROBE_PROVIDE_REQUEST,
	UPROBE_NEED_UPUMP_MGR,
	UPROBE_FREEZE_UPUMP_MGR,
	UPROBE_THAW_UPUMP_MGR,
	UPROBE_NEW_FLOW_DEF,
	UPROBE_NEW_RAP,
	UPROBE_SPLIT_UPDATE,
	UPROBE_SYNC_ACQUIRED,
	UPROBE_SYNC_LOST,
	UPROBE_CLOCK_REF,
	UPROBE_CLOCK_TS,
	UPROBE_CLOCK_UTC,
	UPROBE_LOCAL = 32768,
};
enum upipe_command {
	UPIPE_ATTACH_UREF_MGR,
	UPIPE_ATTACH_UPUMP_MGR,
	UPIPE_ATTACH_UCLOCK,
	UPIPE_GET_URI,
	UPIPE_SET_URI,
	UPIPE_GET_OPTION,
	UPIPE_SET_OPTION,
	UPIPE_REGISTER_REQUEST,
	UPIPE_UNREGISTER_REQUEST,
	UPIPE_SET_FLOW_DEF,
	UPIPE_GET_MAX_LENGTH,
	UPIPE_SET_MAX_LENGTH,
	UPIPE_FLUSH,
	UPIPE_GET_OUTPUT,
	UPIPE_SET_OUTPUT,
	UPIPE_ATTACH_UBUF_MGR,
	UPIPE_GET_FLOW_DEF,
	UPIPE_GET_OUTPUT_SIZE,
	UPIPE_SET_OUTPUT_SIZE,
	UPIPE_SPLIT_ITERATE,
	UPIPE_GET_SUB_MGR,
	UPIPE_ITERATE_SUB,
	UPIPE_SUB_GET_SUPER,
	UPIPE_SRC_GET_SIZE,
	UPIPE_SRC_GET_POSITION,
	UPIPE_SRC_SET_POSITION,
	UPIPE_SRC_SET_RANGE,
	UPIPE_SRC_GET_RANGE,
	UPIPE_CONTROL_LOCAL = 32768,
};
typedef uint32_t volatile uatomic_uint32_t;
typedef void (*urefcount_cb)(struct urefcount *);
struct urefcount {
	uatomic_uint32_t refcount;
	urefcount_cb cb;
};
struct uclock {
	struct urefcount *refcount;
	uint64_t (*uclock_now)(struct uclock *);
	time_t (*uclock_mktime)(struct uclock *, uint64_t);
};
enum uclock_std_flags {
	UCLOCK_FLAG_REALTIME = 1,
};
struct uclock *uclock_std_alloc(enum uclock_std_flags);
struct umem {
	struct umem_mgr *mgr;
	uint8_t *buffer;
	size_t size;
	size_t real_size;
};
struct umem_mgr {
	struct urefcount *refcount;
	bool (*umem_alloc)(struct umem_mgr *, struct umem *, size_t);
	bool (*umem_realloc)(struct umem *, size_t);
	void (*umem_free)(struct umem *);
	void (*umem_mgr_vacuum)(struct umem_mgr *);
};
struct umem_mgr *umem_alloc_mgr_alloc(void);
struct umem_mgr *umem_pool_mgr_alloc(size_t, size_t, ...);
struct umem_mgr *umem_pool_mgr_alloc_simple(uint16_t);
struct uchain {
	struct uchain *next;
	struct uchain *prev;
};
struct ubuf {
	struct uchain uchain;
	struct ubuf_mgr *mgr;
};
struct ubuf_mgr {
	struct urefcount *refcount;
	uint32_t signature;
	struct ubuf *(*ubuf_alloc)(struct ubuf_mgr *, uint32_t, va_list);
	int (*ubuf_control)(struct ubuf *, int, va_list);
	void (*ubuf_free)(struct ubuf *);
	int (*ubuf_mgr_control)(struct ubuf_mgr *, int, va_list);
};
struct ubuf_mgr *ubuf_block_mem_mgr_alloc(uint16_t, uint16_t, struct umem_mgr *, int, int);
struct udict {
	struct udict_mgr *mgr;
};
struct udict_mgr {
	struct urefcount *refcount;
	struct udict *(*udict_alloc)(struct udict_mgr *, size_t);
	int (*udict_control)(struct udict *, int, va_list);
	void (*udict_free)(struct udict *);
	int (*udict_mgr_control)(struct udict_mgr *, int, va_list);
};
struct uref_mgr {
	struct urefcount *refcount;
	size_t control_attr_size;
	struct udict_mgr *udict_mgr;
	struct uref *(*uref_alloc)(struct uref_mgr *);
	void (*uref_free)(struct uref *);
	int (*uref_mgr_control)(struct uref_mgr *, int, va_list);
};
struct uref {
	struct uchain uchain;
	struct uref_mgr *mgr;
	struct ubuf *ubuf;
	struct udict *udict;
	uint64_t flags;
	uint64_t date_sys;
	uint64_t date_prog;
	uint64_t date_orig;
	uint64_t dts_pts_delay;
	uint64_t cr_dts_delay;
	uint64_t rap_cr_delay;
	uint64_t priv;
};
struct ubuf_mgr *ubuf_mem_mgr_alloc_from_flow_def(uint16_t, uint16_t, struct umem_mgr *, struct uref *);
typedef uint16_t uring_index;
struct uring_elem {
	uint16_t tag;
	uring_index next;
	void *opaque;
};
struct uring {
	uint16_t length;
	struct uring_elem *elems;
};
typedef uatomic_uint32_t uring_lifo;
struct ulifo {
	struct uring uring;
	uring_lifo lifo_carrier;
	uring_lifo lifo_empty;
};
typedef void *(*upool_alloc_cb)(struct upool *);
typedef void (*upool_free_cb)(struct upool *, void *);
struct upool {
	struct ulifo lifo;
	upool_alloc_cb alloc_cb;
	upool_free_cb free_cb;
};
void *ubuf_mem_shared_alloc_inner(struct upool *);
void ubuf_mem_shared_free_inner(struct upool *, void *);
int ubuf_pic_common_check_size(struct ubuf_mgr *, int, int);
int ubuf_pic_common_dup(struct ubuf *, struct ubuf *);
int ubuf_pic_common_plane_dup(struct ubuf *, struct ubuf *, uint8_t);
int ubuf_pic_common_size(struct ubuf *, size_t *, size_t *, uint8_t *);
int ubuf_pic_common_plane_iterate(struct ubuf *, char const **);
int ubuf_pic_common_plane_size(struct ubuf *, char const *, size_t *, uint8_t *, uint8_t *, uint8_t *);
int ubuf_pic_common_plane_map(struct ubuf *, char const *, int, int, int, int, uint8_t **);
int ubuf_pic_common_check_skip(struct ubuf_mgr *, int, int);
int ubuf_pic_common_resize(struct ubuf *, int, int, int, int);
void ubuf_pic_common_mgr_clean(struct ubuf_mgr *);
void ubuf_pic_common_mgr_init(struct ubuf_mgr *, uint8_t);
int ubuf_pic_common_mgr_add_plane(struct ubuf_mgr *, char const *, uint8_t, uint8_t, uint8_t);
int ubuf_pic_plane_clear(struct ubuf *, char const *, int, int, int, int, int);
int ubuf_pic_clear(struct ubuf *, int, int, int, int, int);
struct ubuf_mgr *ubuf_pic_mem_mgr_alloc(uint16_t, uint16_t, struct umem_mgr *, uint8_t, int, int, int, int, int, int);
int ubuf_pic_mem_mgr_add_plane(struct ubuf_mgr *, char const *, uint8_t, uint8_t, uint8_t);
struct ubuf_mgr *ubuf_pic_mem_mgr_alloc_fourcc(uint16_t, uint16_t, struct umem_mgr *, char const *, int, int, int, int, int, int);
int ubuf_sound_common_dup(struct ubuf *, struct ubuf *);
int ubuf_sound_common_plane_dup(struct ubuf *, struct ubuf *, uint8_t);
int ubuf_sound_common_size(struct ubuf *, size_t *, uint8_t *);
int ubuf_sound_common_plane_iterate(struct ubuf *, char const **);
int ubuf_sound_common_plane_map(struct ubuf *, char const *, int, int, uint8_t **);
int ubuf_sound_common_resize(struct ubuf *, int, int);
void ubuf_sound_common_mgr_clean(struct ubuf_mgr *);
void ubuf_sound_common_mgr_init(struct ubuf_mgr *, uint8_t);
int ubuf_sound_common_mgr_add_plane(struct ubuf_mgr *, char const *);
struct ubuf_mgr *ubuf_sound_mem_mgr_alloc(uint16_t, uint16_t, struct umem_mgr *, uint8_t, uint64_t);
int ubuf_sound_mem_mgr_add_plane(struct ubuf_mgr *, char const *);
struct udict_mgr *udict_inline_mgr_alloc(unsigned int, struct umem_mgr *, int, int);
struct uref_mgr *uref_std_mgr_alloc(uint16_t, struct udict_mgr *, int);
struct ustring {
	char *at;
	size_t len;
};
struct uuri_authority {
	struct ustring userinfo;
	struct ustring host;
	struct ustring port;
};
struct uuri {
	struct ustring scheme;
	struct uuri_authority authority;
	struct ustring path;
	struct ustring query;
	struct ustring fragment;
};
int uref_uri_set(struct uref *, struct uuri const *);
int uref_uri_get(struct uref *, struct uuri *);
int uref_uri_set_from_str(struct uref *, char const *);
int uref_uri_get_to_str(struct uref *, char **);
struct upump;
struct upipe_mgr {
	struct urefcount *refcount;
	unsigned int signature;
	char const *(*upipe_err_str)(int);
	char const *(*upipe_command_str)(int);
	char const *(*upipe_event_str)(int);
	struct upipe *(*upipe_alloc)(struct upipe_mgr *, struct uprobe *, uint32_t, va_list);
	void (*upipe_input)(struct upipe *, struct uref *, struct upump **);
	int (*upipe_control)(struct upipe *, int, va_list);
	int (*upipe_mgr_control)(struct upipe_mgr *, int, va_list);
};
struct upipe {
	struct urefcount *refcount;
	struct uchain uchain;
	void *opaque;
	struct uprobe *uprobe;
	struct upipe_mgr *mgr;
};
typedef int (*uprobe_throw_func)(struct uprobe *, struct upipe *, int, va_list);
struct uprobe {
	struct urefcount *refcount;
	uprobe_throw_func uprobe_throw;
	struct uprobe *next;
};
void uprobe_dejitter_set(struct uprobe *, bool, uint64_t);
struct urational {
	int64_t num;
	uint64_t den;
};
struct uprobe_dejitter {
	unsigned int offset_divider;
	unsigned int deviation_divider;
	unsigned int offset_count;
	double offset;
	unsigned int deviation_count;
	double deviation;
	uint64_t last_cr_prog;
	uint64_t last_cr_sys;
	struct urational drift_rate;
	uint64_t last_print;
	struct uprobe uprobe;
};
struct uprobe *uprobe_dejitter_init(struct uprobe_dejitter *, struct uprobe *, bool, uint64_t);
void uprobe_dejitter_clean(struct uprobe_dejitter *);
struct uprobe *uprobe_dejitter_alloc(struct uprobe *, bool, uint64_t);
enum uprobe_log_level {
	UPROBE_LOG_VERBOSE,
	UPROBE_LOG_DEBUG,
	UPROBE_LOG_NOTICE,
	UPROBE_LOG_WARNING,
	UPROBE_LOG_ERROR,
};
struct uprobe_loglevel {
	enum uprobe_log_level min_level;
	struct uprobe uprobe;
	struct uchain patterns;
};
struct uprobe *uprobe_loglevel_init(struct uprobe_loglevel *, struct uprobe *, enum uprobe_log_level);
void uprobe_loglevel_clean(struct uprobe_loglevel *);
struct uprobe *uprobe_loglevel_alloc(struct uprobe *, enum uprobe_log_level);
int uprobe_loglevel_set(struct uprobe *, char const *, enum uprobe_log_level);
struct uprobe_pfx {
	char *name;
	enum uprobe_log_level min_level;
	struct uprobe uprobe;
};
struct uprobe *uprobe_pfx_init(struct uprobe_pfx *, struct uprobe *, enum uprobe_log_level, char const *);
void uprobe_pfx_clean(struct uprobe_pfx *);
struct uprobe *uprobe_pfx_alloc(struct uprobe *, enum uprobe_log_level, char const *);
struct uprobe *uprobe_pfx_alloc_va(struct uprobe *, enum uprobe_log_level, char const *, ...);
struct uprobe_output {
	struct uprobe uprobe;
};
struct uprobe *uprobe_output_init(struct uprobe_output *, struct uprobe *);
void uprobe_output_clean(struct uprobe_output *);
struct uprobe *uprobe_output_alloc(struct uprobe *);
enum uprobe_selflow_type {
	UPROBE_SELFLOW_VOID,
	UPROBE_SELFLOW_PIC,
	UPROBE_SELFLOW_SOUND,
	UPROBE_SELFLOW_SUBPIC,
};
struct uprobe *uprobe_selflow_alloc(struct uprobe *, struct uprobe *, enum uprobe_selflow_type, char const *);
void uprobe_selflow_get(struct uprobe *, char const **);
int uprobe_selflow_set(struct uprobe *, char const *);
int uprobe_selflow_set_va(struct uprobe *, char const *, ...);
struct uprobe_stdio {
	FILE *stream;
	enum uprobe_log_level min_level;
	struct uprobe uprobe;
};
struct uprobe *uprobe_stdio_init(struct uprobe_stdio *, struct uprobe *, FILE *, enum uprobe_log_level);
void uprobe_stdio_clean(struct uprobe_stdio *);
struct uprobe *uprobe_stdio_alloc(struct uprobe *, FILE *, enum uprobe_log_level);
struct uprobe_stdio_color {
	FILE *stream;
	enum uprobe_log_level min_level;
	struct uprobe uprobe;
};
struct uprobe *uprobe_stdio_color_init(struct uprobe_stdio_color *, struct uprobe *, FILE *, enum uprobe_log_level);
void uprobe_stdio_color_clean(struct uprobe_stdio_color *);
struct uprobe *uprobe_stdio_color_alloc(struct uprobe *, FILE *, enum uprobe_log_level);
struct uprobe_syslog {
	char *ident;
	int facility;
	bool inited;
	enum uprobe_log_level min_level;
	struct uprobe uprobe;
};
struct uprobe *uprobe_syslog_init(struct uprobe_syslog *, struct uprobe *, char const *, int, int, enum uprobe_log_level);
void uprobe_syslog_clean(struct uprobe_syslog *);
struct uprobe *uprobe_syslog_alloc(struct uprobe *, char const *, int, int, enum uprobe_log_level);
struct uprobe_xfer {
	struct uchain subs;
	struct uprobe uprobe;
};
struct uprobe *uprobe_xfer_init(struct uprobe_xfer *, struct uprobe *);
void uprobe_xfer_clean(struct uprobe_xfer *);
struct uprobe *uprobe_xfer_alloc(struct uprobe *);
enum uprobe_xfer_event {
	UPROBE_XFER_SENTINEL = 65536,
	UPROBE_XFER_VOID,
	UPROBE_XFER_UINT64_T,
	UPROBE_XFER_UNSIGNED_LONG_LOCAL,
};
int uprobe_xfer_add(struct uprobe *, enum uprobe_xfer_event, int, uint32_t);
struct uprobe_ubuf_mem {
	struct umem_mgr *umem_mgr;
	uint16_t ubuf_pool_depth;
	uint16_t shared_pool_depth;
	struct uprobe uprobe;
};
struct uprobe *uprobe_ubuf_mem_init(struct uprobe_ubuf_mem *, struct uprobe *, struct umem_mgr *, uint16_t, uint16_t);
void uprobe_ubuf_mem_clean(struct uprobe_ubuf_mem *);
struct uprobe *uprobe_ubuf_mem_alloc(struct uprobe *, struct umem_mgr *, uint16_t, uint16_t);
void uprobe_ubuf_mem_set(struct uprobe *, struct umem_mgr *);
typedef void *volatile uatomic_ptr_t;
struct uprobe_ubuf_mem_pool {
	struct umem_mgr *umem_mgr;
	uint16_t ubuf_pool_depth;
	uint16_t shared_pool_depth;
	uatomic_ptr_t first;
	struct uprobe uprobe;
};
struct uprobe *uprobe_ubuf_mem_pool_init(struct uprobe_ubuf_mem_pool *, struct uprobe *, struct umem_mgr *, uint16_t, uint16_t);
void uprobe_ubuf_mem_pool_vacuum(struct uprobe_ubuf_mem_pool *);
void uprobe_ubuf_mem_pool_clean(struct uprobe_ubuf_mem_pool *);
struct uprobe *uprobe_ubuf_mem_pool_alloc(struct uprobe *, struct umem_mgr *, uint16_t, uint16_t);
void uprobe_ubuf_mem_pool_set(struct uprobe *, struct umem_mgr *);
struct uprobe_uclock {
	struct uclock *uclock;
	struct uprobe uprobe;
};
struct uprobe *uprobe_uclock_init(struct uprobe_uclock *, struct uprobe *, struct uclock *);
void uprobe_uclock_clean(struct uprobe_uclock *);
struct uprobe *uprobe_uclock_alloc(struct uprobe *, struct uclock *);
void uprobe_uclock_set(struct uprobe *, struct uclock *);
enum upump_type {
	UPUMP_TYPE_IDLER,
	UPUMP_TYPE_TIMER,
	UPUMP_TYPE_FD_READ,
	UPUMP_TYPE_FD_WRITE,
};
struct upump_blocker;
struct upump_mgr {
	struct urefcount *refcount;
	struct uchain uchain;
	void *opaque;
	struct upump *(*upump_alloc)(struct upump_mgr *, enum upump_type, va_list);
	void (*upump_start)(struct upump *);
	void (*upump_stop)(struct upump *);
	void (*upump_free)(struct upump *);
	struct upump_blocker *(*upump_blocker_alloc)(struct upump *);
	void (*upump_blocker_free)(struct upump_blocker *);
	int (*upump_mgr_control)(struct upump_mgr *, int, va_list);
};
struct uprobe_upump_mgr {
	struct upump_mgr *upump_mgr;
	bool frozen;
	struct uprobe uprobe;
};
struct uprobe *uprobe_upump_mgr_init(struct uprobe_upump_mgr *, struct uprobe *, struct upump_mgr *);
void uprobe_upump_mgr_clean(struct uprobe_upump_mgr *);
struct uprobe *uprobe_upump_mgr_alloc(struct uprobe *, struct upump_mgr *);
void uprobe_upump_mgr_set(struct uprobe *, struct upump_mgr *);
struct uprobe_uref_mgr {
	struct uref_mgr *uref_mgr;
	struct uprobe uprobe;
};
struct uprobe *uprobe_uref_mgr_init(struct uprobe_uref_mgr *, struct uprobe *, struct uref_mgr *);
void uprobe_uref_mgr_clean(struct uprobe_uref_mgr *);
struct uprobe *uprobe_uref_mgr_alloc(struct uprobe *, struct uref_mgr *);
void uprobe_uref_mgr_set(struct uprobe *, struct uref_mgr *);
struct upump_blocker *upump_common_blocker_alloc(struct upump *);
void upump_common_blocker_free(struct upump_blocker *);
void upump_common_blocker_free_inner(struct upool *, void *);
void upump_common_init(struct upump *);
void upump_common_dispatch(struct upump *);
void upump_common_start(struct upump *);
void upump_common_stop(struct upump *);
void upump_common_clean(struct upump *);
size_t upump_common_mgr_sizeof(uint16_t, uint16_t);
void upump_common_mgr_vacuum(struct upump_mgr *);
void upump_common_mgr_clean(struct upump_mgr *);
void upump_common_mgr_init(struct upump_mgr *, uint16_t, uint16_t, void *, void (*)(struct upump *), void (*)(struct upump *), void *(*)(struct upool *), void (*)(struct upool *, void *));
ssize_t uuri_escape(char const *, char *, size_t);
ssize_t uuri_unescape(char const *, char *, size_t);
struct ustring uuri_parse_ipv4(struct ustring *);
struct ustring uuri_parse_ipv6(struct ustring *);
struct ustring uuri_parse_ipv6_scoped(struct ustring *);
struct ustring uuri_parse_ipvfuture(struct ustring *);
struct ustring uuri_parse_scheme(struct ustring *);
struct ustring uuri_parse_userinfo(struct ustring *);
struct ustring uuri_parse_host(struct ustring *);
struct ustring uuri_parse_port(struct ustring *);
struct uuri_authority uuri_parse_authority(struct ustring *);
struct ustring uuri_parse_path(struct ustring *);
struct ustring uuri_parse_query(struct ustring *);
struct ustring uuri_parse_fragment(struct ustring *);
struct uuri uuri_parse(struct ustring *);
int uuri_authority_len(struct uuri_authority const *, size_t *);
int uuri_len(struct uuri const *, size_t *);
int uuri_authority_to_buffer(struct uuri_authority const *, char *, size_t);
int uuri_to_buffer(struct uuri *, char *, size_t);
int uuri_to_str(struct uuri *, char **);
struct ucookie {
	struct ustring name;
	struct ustring value;
	struct ustring expires;
	struct ustring max_age;
	struct ustring domain;
	struct ustring path;
	bool secure;
	bool http_only;
};
int ucookie_from_str(struct ucookie *, char const *);
void urefcount_release(struct urefcount *);
bool urefcount_single(struct urefcount *);
bool urefcount_dead(struct urefcount *);
int ubuf_block_check_size(struct ubuf *, int *, int *);
struct uring_elem *uring_elem_from_index(struct uring *, uring_index);
typedef uint32_t uring_lifo_val;
uring_index uring_lifo_to_index(struct uring *, uring_lifo_val);
uring_lifo_val uring_lifo_from_index(struct uring *, uring_index);
typedef uint32_t uring_fifo_val;
void uring_fifo_set_head(struct uring *, uring_fifo_val *, uring_index);
uring_index uring_fifo_get_tail(struct uring *, uring_fifo_val);
uring_index uring_fifo_get_head(struct uring *, uring_fifo_val);
uring_lifo_val uring_init(struct uring *, uint16_t, void *);
enum ueventfd_mode {
	UEVENTFD_MODE_EVENTFD,
	UEVENTFD_MODE_PIPE,
};
struct ueventfd {
	enum ueventfd_mode mode;
	union {
		int event_fd;
		int pipe_fds[2];
	};
};
typedef void (*upump_cb)(struct upump *);
struct upump *ueventfd_upump_alloc(struct ueventfd *, struct upump_mgr *, upump_cb, void *);
bool ueventfd_read(struct ueventfd *);
bool ueventfd_write(struct ueventfd *);
void ueventfd_clean(struct ueventfd *);
enum udict_type {
	UDICT_TYPE_END,
	UDICT_TYPE_OPAQUE,
	UDICT_TYPE_STRING,
	UDICT_TYPE_VOID,
	UDICT_TYPE_BOOL,
	UDICT_TYPE_SMALL_UNSIGNED,
	UDICT_TYPE_SMALL_INT,
	UDICT_TYPE_UNSIGNED,
	UDICT_TYPE_INT,
	UDICT_TYPE_RATIONAL,
	UDICT_TYPE_FLOAT,
	UDICT_TYPE_SHORTHAND = 16,
	UDICT_TYPE_FLOW_RANDOM,
	UDICT_TYPE_FLOW_ERROR,
	UDICT_TYPE_FLOW_DEF,
	UDICT_TYPE_FLOW_ID,
	UDICT_TYPE_FLOW_RAWDEF,
	UDICT_TYPE_FLOW_LANGUAGES,
	UDICT_TYPE_EVENT_EVENTS,
	UDICT_TYPE_CLOCK_DURATION,
	UDICT_TYPE_CLOCK_RATE,
	UDICT_TYPE_CLOCK_LATENCY,
	UDICT_TYPE_BLOCK_END,
	UDICT_TYPE_PIC_NUM,
	UDICT_TYPE_PIC_KEY,
	UDICT_TYPE_PIC_HSIZE,
	UDICT_TYPE_PIC_VSIZE,
	UDICT_TYPE_PIC_HSIZE_VISIBLE,
	UDICT_TYPE_PIC_VSIZE_VISIBLE,
	UDICT_TYPE_PIC_VIDEO_FORMAT,
	UDICT_TYPE_PIC_FULL_RANGE,
	UDICT_TYPE_PIC_COLOUR_PRIMARIES,
	UDICT_TYPE_PIC_TRANSFER_CHARACTERISTICS,
	UDICT_TYPE_PIC_MATRIX_COEFFICIENTS,
	UDICT_TYPE_PIC_HPOSITION,
	UDICT_TYPE_PIC_VPOSITION,
	UDICT_TYPE_PIC_SAR,
	UDICT_TYPE_PIC_OVERSCAN,
	UDICT_TYPE_PIC_PROGRESSIVE,
	UDICT_TYPE_PIC_TF,
	UDICT_TYPE_PIC_BF,
	UDICT_TYPE_PIC_TFF,
	UDICT_TYPE_PIC_AFD,
	UDICT_TYPE_PIC_CEA_708,
};
int udict_get_string(struct udict *, char const **, enum udict_type, char const *);
int udict_get_bool(struct udict *, bool *, enum udict_type, char const *);
int udict_get_small_unsigned(struct udict *, uint8_t *, enum udict_type, char const *);
int udict_get_small_int(struct udict *, int8_t *, enum udict_type, char const *);
int udict_get_unsigned(struct udict *, uint64_t *, enum udict_type, char const *);
int udict_get_int(struct udict *, int64_t *, enum udict_type, char const *);
int udict_get_float(struct udict *, double *, enum udict_type, char const *);
int udict_get_rational(struct udict *, struct urational *, enum udict_type, char const *);
void udict_set_int64(uint8_t *, int64_t);
typedef uatomic_uint32_t uring_fifo;
struct ufifo {
	struct uring uring;
	uring_fifo fifo_carrier;
	uring_lifo lifo_empty;
};
bool ufifo_push(struct ufifo *, void *);
typedef int (*urequest_func)(struct urequest *, va_list);
typedef void (*urequest_free_func)(struct urequest *);
struct urequest {
	struct uchain uchain;
	void *opaque;
	int type;
	struct uref *uref;
	urequest_func urequest_provide;
	urequest_free_func urequest_free;
};
void urequest_init(struct urequest *, int, struct uref *, urequest_func, urequest_free_func);
int upipe_control_nodbg_va(struct upipe *, int, va_list);
void uchain_init(struct uchain *);
char const *ubase_err_str(int);
bool ubase_check(int);
uint64_t ubase_gcd(uint64_t, uint64_t);
void urational_simplify(struct urational *);
struct urational urational_add(struct urational const *, struct urational const *);
struct urational urational_multiply(struct urational const *, struct urational const *);
struct urational urational_divide(struct urational const *, struct urational const *);
int ubase_ncmp(char const *, char const *);
void ubase_clean_ptr(void **);
void ubase_clean_str(char **);
void ubase_clean_data(uint8_t **);
void ubase_clean_fd(int *);
void uatomic_init(uatomic_uint32_t *, uint32_t);
void uatomic_store(uatomic_uint32_t *, uint32_t);
uint32_t uatomic_load(uatomic_uint32_t *);
bool uatomic_compare_exchange(uatomic_uint32_t *, uint32_t *, uint32_t);
void uatomic_clean(uatomic_uint32_t *);
void uatomic_ptr_init(uatomic_ptr_t *, void *);
void uatomic_ptr_store(uatomic_ptr_t *, void *);
void *uatomic_ptr_load(uatomic_ptr_t *);
bool uatomic_ptr_compare_exchange(uatomic_ptr_t *, void **, void *);
void uatomic_ptr_clean(uatomic_ptr_t *);
uint32_t uatomic_fetch_add(uatomic_uint32_t *, uint32_t);
uint32_t uatomic_fetch_sub(uatomic_uint32_t *, uint32_t);
void urefcount_init(struct urefcount *, urefcount_cb);
void urefcount_reset(struct urefcount *);
struct urefcount *urefcount_use(struct urefcount *);
void urefcount_clean(struct urefcount *);
struct ubuf *ubuf_alloc(struct ubuf_mgr *, uint32_t, ...);
int ubuf_control_va(struct ubuf *, int, va_list);
int ubuf_control(struct ubuf *, int, ...);
struct ubuf *ubuf_dup(struct ubuf *);
void ubuf_free(struct ubuf *);
struct ubuf_mgr *ubuf_mgr_use(struct ubuf_mgr *);
void ubuf_mgr_release(struct ubuf_mgr *);
int ubuf_mgr_control_va(struct ubuf_mgr *, int, va_list);
int ubuf_mgr_control(struct ubuf_mgr *, int, ...);
int ubuf_mgr_check(struct ubuf_mgr *, struct uref *);
int ubuf_mgr_vacuum(struct ubuf_mgr *);
struct ubuf *ubuf_block_alloc(struct ubuf_mgr *, int);
int ubuf_block_size(struct ubuf *, size_t *);
struct ubuf *ubuf_block_get(struct ubuf *, int *, int *);
int ubuf_block_size_linear(struct ubuf *, int, size_t *);
int ubuf_block_read(struct ubuf *, int, int *, uint8_t const **);
int ubuf_block_write(struct ubuf *, int, int *, uint8_t **);
int ubuf_block_unmap(struct ubuf *, int);
int ubuf_block_append(struct ubuf *, struct ubuf *);
int ubuf_block_split(struct ubuf *, int);
int ubuf_block_insert(struct ubuf *, int, struct ubuf *);
int ubuf_block_delete(struct ubuf *, int, int);
int ubuf_block_truncate(struct ubuf *, int);
int ubuf_block_resize(struct ubuf *, int, int);
struct ubuf *ubuf_block_splice(struct ubuf *, int, int);
uint8_t const *ubuf_block_peek(struct ubuf *, int, int, uint8_t *);
int ubuf_block_peek_unmap(struct ubuf *, int, uint8_t *, uint8_t const *);
int ubuf_block_extract(struct ubuf *, int, int, uint8_t *);
int ubuf_block_iovec_count(struct ubuf *, int, int);
int ubuf_block_iovec_read(struct ubuf *, int, int, struct iovec *);
int ubuf_block_iovec_unmap(struct ubuf *, int, int, struct iovec *);
bool ubuf_block_check_resize(struct ubuf *, int *, int *, size_t *);
struct ubuf *ubuf_block_copy(struct ubuf_mgr *, struct ubuf *, int, int);
int ubuf_block_merge(struct ubuf_mgr *, struct ubuf **, int, int);
int ubuf_block_compare(struct ubuf *, int, struct ubuf *);
int ubuf_block_equal(struct ubuf *, struct ubuf *);
int ubuf_block_match(struct ubuf *, uint8_t const *, uint8_t const *, size_t);
int ubuf_block_scan(struct ubuf *, size_t *, uint8_t);
int ubuf_block_find_va(struct ubuf *, size_t *, unsigned int, va_list);
int ubuf_block_find(struct ubuf *, size_t *, unsigned int, ...);
void ubuf_block_common_init(struct ubuf *, bool);
void ubuf_block_common_set(struct ubuf *, size_t, size_t);
void ubuf_block_common_set_buffer(struct ubuf *, uint8_t *);
int ubuf_block_common_dup(struct ubuf *, struct ubuf *);
int ubuf_block_common_splice(struct ubuf *, struct ubuf *, int, int);
void ubuf_block_common_clean(struct ubuf *);
struct ubuf_block_stream {
	struct ubuf *ubuf;
	uint8_t const *buffer;
	uint8_t const *end;
	int offset;
	int size;
	uint32_t bits;
	uint32_t available;
	bool overflow;
};
int ubuf_block_stream_init(struct ubuf_block_stream *, struct ubuf *, int);
int ubuf_block_stream_clean(struct ubuf_block_stream *);
int ubuf_block_stream_get(struct ubuf_block_stream *, uint8_t *);
void uring_elem_set(struct uring *, uring_index, void *);
void *uring_elem_get(struct uring *, uring_index);
void uring_lifo_init(struct uring *, uring_lifo *, uring_lifo_val);
void uring_lifo_clean(struct uring *, uring_lifo *);
uring_index uring_lifo_pop(struct uring *, uring_lifo *);
void uring_lifo_push(struct uring *, uring_lifo *, uring_index);
void uring_fifo_set_tail(struct uring *, uring_fifo_val *, uring_index);
uring_index uring_fifo_find(struct uring *, uring_index, uring_index);
uring_index uring_fifo_pop(struct uring *, uring_fifo *);
void uring_fifo_push(struct uring *, uring_fifo *, uring_index);
void uring_fifo_init(struct uring *, uring_fifo *);
void uring_fifo_clean(struct uring *, uring_fifo *);
void ulifo_init(struct ulifo *, uint16_t, void *);
bool ulifo_push(struct ulifo *, void *);
void *ulifo_pop_internal(struct ulifo *);
void ulifo_clean(struct ulifo *);
void upool_init(struct upool *, uint16_t, void *, upool_alloc_cb, upool_free_cb);
void *upool_alloc_internal(struct upool *);
void upool_free(struct upool *, void *);
void upool_vacuum(struct upool *);
void upool_clean(struct upool *);
uint8_t *umem_buffer(struct umem *);
size_t umem_size(struct umem *);
bool umem_alloc(struct umem_mgr *, struct umem *, size_t);
bool umem_realloc(struct umem *, size_t);
void umem_free(struct umem *);
void umem_mgr_vacuum(struct umem_mgr *);
struct umem_mgr *umem_mgr_use(struct umem_mgr *);
void umem_mgr_release(struct umem_mgr *);
struct ubuf_mem_shared {
	uatomic_uint32_t refcount;
	struct umem umem;
};
struct ubuf_mem_shared *ubuf_mem_shared_use(struct ubuf_mem_shared *);
bool ubuf_mem_shared_release(struct ubuf_mem_shared *);
bool ubuf_mem_shared_single(struct ubuf_mem_shared *);
uint8_t *ubuf_mem_shared_buffer(struct ubuf_mem_shared *);
size_t ubuf_mem_shared_size(struct ubuf_mem_shared *);
int ubuf_pic_common_plane(struct ubuf_mgr *, char const *);
size_t ubuf_pic_common_sizeof(struct ubuf_mgr *);
void ubuf_pic_common_init(struct ubuf *, size_t, size_t, size_t, size_t, size_t, size_t);
void ubuf_pic_common_clean(struct ubuf *);
void ubuf_pic_common_plane_init(struct ubuf *, uint8_t, uint8_t *, size_t);
void ubuf_pic_common_plane_clean(struct ubuf *, uint8_t);
struct ubuf *ubuf_pic_alloc(struct ubuf_mgr *, int, int);
int ubuf_pic_size(struct ubuf *, size_t *, size_t *, uint8_t *);
int ubuf_pic_plane_iterate(struct ubuf *, char const **);
int ubuf_pic_plane_size(struct ubuf *, char const *, size_t *, uint8_t *, uint8_t *, uint8_t *);
int ubuf_pic_plane_check_offset(struct ubuf *, char const *, int *, int *, int *, int *);
int ubuf_pic_plane_read(struct ubuf *, char const *, int, int, int, int, uint8_t const **);
int ubuf_pic_plane_write(struct ubuf *, char const *, int, int, int, int, uint8_t **);
int ubuf_pic_plane_unmap(struct ubuf *, char const *, int, int, int, int);
int ubuf_pic_check_resize(struct ubuf *, int *, int *, int *, int *, size_t *, size_t *, uint8_t *);
int ubuf_pic_resize(struct ubuf *, int, int, int, int);
int ubuf_pic_blit(struct ubuf *, struct ubuf *, int, int, int, int, int, int);
struct ubuf *ubuf_pic_copy(struct ubuf_mgr *, struct ubuf *, int, int, int, int);
int ubuf_pic_replace(struct ubuf_mgr *, struct ubuf **, int, int, int, int);
int ubuf_sound_common_plane(struct ubuf_mgr *, char const *);
size_t ubuf_sound_common_sizeof(struct ubuf_mgr *);
void ubuf_sound_common_init(struct ubuf *, size_t);
void ubuf_sound_common_clean(struct ubuf *);
void ubuf_sound_common_plane_init(struct ubuf *, uint8_t, uint8_t *);
void ubuf_sound_common_plane_clean(struct ubuf *, uint8_t);
struct ubuf *ubuf_sound_alloc(struct ubuf_mgr *, int);
int ubuf_sound_size(struct ubuf *, size_t *, uint8_t *);
int ubuf_sound_plane_iterate(struct ubuf *, char const **);
int ubuf_sound_plane_unmap(struct ubuf *, char const *, int, int);
int ubuf_sound_unmap(struct ubuf *, int, int, uint8_t);
int ubuf_sound_plane_read_void(struct ubuf *, char const *, int, int, void const **);
int ubuf_sound_plane_write_void(struct ubuf *, char const *, int, int, void **);
int ubuf_sound_read_void(struct ubuf *, int, int, void const **, uint8_t);
int ubuf_sound_write_void(struct ubuf *, int, int, void **, uint8_t);
int ubuf_sound_plane_read_uint8_t(struct ubuf *, char const *, int, int, uint8_t const **);
int ubuf_sound_plane_write_uint8_t(struct ubuf *, char const *, int, int, uint8_t **);
int ubuf_sound_read_uint8_t(struct ubuf *, int, int, uint8_t const **, uint8_t);
int ubuf_sound_write_uint8_t(struct ubuf *, int, int, uint8_t **, uint8_t);
int ubuf_sound_plane_read_int16_t(struct ubuf *, char const *, int, int, int16_t const **);
int ubuf_sound_plane_write_int16_t(struct ubuf *, char const *, int, int, int16_t **);
int ubuf_sound_read_int16_t(struct ubuf *, int, int, int16_t const **, uint8_t);
int ubuf_sound_write_int16_t(struct ubuf *, int, int, int16_t **, uint8_t);
int ubuf_sound_plane_read_int32_t(struct ubuf *, char const *, int, int, int32_t const **);
int ubuf_sound_plane_write_int32_t(struct ubuf *, char const *, int, int, int32_t **);
int ubuf_sound_read_int32_t(struct ubuf *, int, int, int32_t const **, uint8_t);
int ubuf_sound_write_int32_t(struct ubuf *, int, int, int32_t **, uint8_t);
int ubuf_sound_plane_read_float(struct ubuf *, char const *, int, int, float const **);
int ubuf_sound_plane_write_float(struct ubuf *, char const *, int, int, float **);
int ubuf_sound_read_float(struct ubuf *, int, int, float const **, uint8_t);
int ubuf_sound_write_float(struct ubuf *, int, int, float **, uint8_t);
int ubuf_sound_plane_read_double(struct ubuf *, char const *, int, int, double const **);
int ubuf_sound_plane_write_double(struct ubuf *, char const *, int, int, double **);
int ubuf_sound_read_double(struct ubuf *, int, int, double const **, uint8_t);
int ubuf_sound_write_double(struct ubuf *, int, int, double **, uint8_t);
int ubuf_sound_resize(struct ubuf *, int, int);
struct ubuf *ubuf_sound_copy(struct ubuf_mgr *, struct ubuf *, int, int);
int ubuf_sound_interleave(struct ubuf *, uint8_t *, int, int, uint8_t, uint8_t);
int ubuf_sound_replace(struct ubuf_mgr *, struct ubuf **, int, int);
uint64_t uclock_now(struct uclock *);
time_t uclock_mktime(struct uclock *, uint64_t);
struct uclock *uclock_use(struct uclock *);
void uclock_release(struct uclock *);
struct ustring ustring_null(void);
struct ustring ustring_from_str(char const *);
bool ustring_is_null(struct ustring const);
bool ustring_is_empty(struct ustring const);
int ustring_to_str(struct ustring const, char **);
int ustring_cpy(struct ustring const, char *, size_t);
struct ustring ustring_sub(struct ustring, size_t, size_t);
struct ustring ustring_shift(struct ustring const, size_t);
struct ustring ustring_truncate(struct ustring const, size_t);
struct ustring ustring_while(struct ustring const, char const *);
struct ustring ustring_until(struct ustring const, char const *);
struct ustring ustring_shift_while(struct ustring const, char const *);
struct ustring ustring_shift_until(struct ustring const, char const *);
int ustring_ncmp(struct ustring const, struct ustring const, size_t);
int ustring_ncasecmp(struct ustring const, struct ustring const, size_t);
int ustring_cmp(struct ustring const, struct ustring const);
int ustring_casecmp(struct ustring const, struct ustring const);
bool ustring_match(struct ustring const, struct ustring const);
bool ustring_match_str(struct ustring const, char const *);
bool ustring_casematch(struct ustring const, struct ustring const);
bool ustring_match_sfx(struct ustring const, struct ustring const);
bool ustring_casematch_sfx(struct ustring const, struct ustring const);
struct ustring ustring_split_while(struct ustring *, char const *);
struct ustring ustring_split_until(struct ustring *, char const *);
struct ustring ustring_split_sep(struct ustring *, char const *);
struct ustring ustring_split_match(struct ustring *, struct ustring const);
struct ustring ustring_split_match_str(struct ustring *, char const *);
struct ustring ustring_split_casematch(struct ustring *, struct ustring const);
struct ustring ustring_split_casematch_str(struct ustring *, char const *);
struct ucookie ucookie_null(void);
void ulist_init(struct uchain *);
bool ulist_is_first(struct uchain *, struct uchain *);
bool ulist_is_last(struct uchain *, struct uchain *);
bool ulist_is_in(struct uchain *);
bool ulist_empty(struct uchain *);
size_t ulist_depth(struct uchain *);
void ulist_insert(struct uchain *, struct uchain *, struct uchain *);
void ulist_delete(struct uchain *);
void ulist_add(struct uchain *, struct uchain *);
void ulist_unshift(struct uchain *, struct uchain *);
struct uchain *ulist_peek(struct uchain *);
struct uchain *ulist_pop(struct uchain *);
struct uchain *ulist_at(struct uchain *, unsigned int);
void ulist_sort(struct uchain *, int (*)(struct uchain **, struct uchain **));
struct upump *upump_alloc(struct upump_mgr *, upump_cb, void *, enum upump_type, ...);
struct upump *upump_alloc_idler(struct upump_mgr *, upump_cb, void *);
struct upump *upump_alloc_timer(struct upump_mgr *, upump_cb, void *, uint64_t, uint64_t);
struct upump *upump_alloc_fd_read(struct upump_mgr *, upump_cb, void *, int);
struct upump *upump_alloc_fd_write(struct upump_mgr *, upump_cb, void *, int);
void upump_start(struct upump *);
void upump_stop(struct upump *);
void upump_free(struct upump *);
void upump_set_cb(struct upump *, upump_cb, void *);
struct upump_mgr *upump_mgr_use(struct upump_mgr *);
void upump_mgr_release(struct upump_mgr *);
void upump_mgr_set_opaque(struct upump_mgr *, void *);
int upump_mgr_control_va(struct upump_mgr *, int, va_list);
int upump_mgr_control(struct upump_mgr *, int, ...);
int upump_mgr_vacuum(struct upump_mgr *);
bool ueventfd_init(struct ueventfd *, bool);
struct udeal {
	uatomic_uint32_t waiters;
	uatomic_uint32_t access;
	struct ueventfd event;
};
bool udeal_init(struct udeal *);
struct upump *udeal_upump_alloc(struct udeal *, struct upump_mgr *, upump_cb, void *);
void udeal_start(struct udeal *, struct upump *);
bool udeal_grab(struct udeal *);
void udeal_yield(struct udeal *, struct upump *);
void udeal_abort(struct udeal *, struct upump *);
void udeal_clean(struct udeal *);
struct udict *udict_alloc(struct udict_mgr *, size_t);
int udict_control_va(struct udict *, int, va_list);
int udict_control(struct udict *, int, ...);
struct udict *udict_dup(struct udict *);
int udict_iterate(struct udict *, char const **, enum udict_type *);
int udict_get(struct udict *, char const *, enum udict_type, size_t *, uint8_t const **);
struct udict_opaque {
	uint8_t const *v;
	size_t size;
};
int udict_get_opaque(struct udict *, struct udict_opaque *, enum udict_type, char const *);
int udict_get_void(struct udict *, void *, enum udict_type, char const *);
uint64_t udict_get_uint64(uint8_t const *);
int64_t udict_get_int64(uint8_t const *);
int udict_set(struct udict *, char const *, enum udict_type, size_t, uint8_t **);
int udict_set_opaque(struct udict *, struct udict_opaque, enum udict_type, char const *);
int udict_set_string(struct udict *, char const *, enum udict_type, char const *);
int udict_set_void(struct udict *, void *, enum udict_type, char const *);
int udict_set_bool(struct udict *, bool, enum udict_type, char const *);
int udict_set_small_unsigned(struct udict *, uint8_t, enum udict_type, char const *);
int udict_set_small_int(struct udict *, int8_t, enum udict_type, char const *);
void udict_set_uint64(uint8_t *, uint64_t);
int udict_set_unsigned(struct udict *, uint64_t, enum udict_type, char const *);
int udict_set_int(struct udict *, uint64_t, enum udict_type, char const *);
int udict_set_float(struct udict *, double, enum udict_type, char const *);
int udict_set_rational(struct udict *, struct urational, enum udict_type, char const *);
int udict_delete(struct udict *, enum udict_type, char const *);
int udict_name(struct udict *, enum udict_type, char const **, enum udict_type *);
void udict_free(struct udict *);
int udict_import(struct udict *, struct udict *);
struct udict *udict_copy(struct udict_mgr *, struct udict *);
int udict_cmp(struct udict *, struct udict *);
struct udict_mgr *udict_mgr_use(struct udict_mgr *);
void udict_mgr_release(struct udict_mgr *);
int udict_mgr_control_va(struct udict_mgr *, int, va_list);
int udict_mgr_control(struct udict_mgr *, int, ...);
int udict_mgr_vacuum(struct udict_mgr *);
char const *uref_date_type_str(int);
void uref_free(struct uref *);
void uref_init(struct uref *);
struct uref *uref_alloc(struct uref_mgr *);
struct uref *uref_sibling_alloc(struct uref *);
struct uref *uref_alloc_control(struct uref_mgr *);
struct uref *uref_sibling_alloc_control(struct uref *);
struct uref *uref_dup_inner(struct uref *);
struct uref *uref_dup(struct uref *);
void uref_attach_ubuf(struct uref *, struct ubuf *);
struct ubuf *uref_detach_ubuf(struct uref *);
struct uref_mgr *uref_mgr_use(struct uref_mgr *);
void uref_mgr_release(struct uref_mgr *);
int uref_mgr_control_va(struct uref_mgr *, int, va_list);
int uref_mgr_control(struct uref_mgr *, int, ...);
int uref_mgr_vacuum(struct uref_mgr *);
int uref_attr_import(struct uref *, struct uref *);
int uref_attr_copy_list(struct uref *, struct uref *, int (**)(struct uref *, struct uref *), size_t);
int uref_attr_delete(struct uref *, enum udict_type, char const *);
int uref_attr_delete_va(struct uref *, enum udict_type, char const *, ...);
int uref_attr_delete_list(struct uref *, int (**)(struct uref *), size_t);
int uref_attr_get_opaque(struct uref *, struct udict_opaque *, enum udict_type, char const *);
int uref_attr_get_opaque_va(struct uref *, struct udict_opaque *, enum udict_type, char const *, ...);
int uref_attr_set_opaque(struct uref *, struct udict_opaque, enum udict_type, char const *);
int uref_attr_set_opaque_va(struct uref *, struct udict_opaque, enum udict_type, char const *, ...);
int uref_attr_copy_opaque(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_opaque_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_string(struct uref *, char const **, enum udict_type, char const *);
int uref_attr_get_string_va(struct uref *, char const **, enum udict_type, char const *, ...);
int uref_attr_set_string(struct uref *, char const *, enum udict_type, char const *);
int uref_attr_set_string_va(struct uref *, char const *, enum udict_type, char const *, ...);
int uref_attr_copy_string(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_string_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_void(struct uref *, void **, enum udict_type, char const *);
int uref_attr_get_void_va(struct uref *, void **, enum udict_type, char const *, ...);
int uref_attr_set_void(struct uref *, void *, enum udict_type, char const *);
int uref_attr_set_void_va(struct uref *, void *, enum udict_type, char const *, ...);
int uref_attr_copy_void(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_void_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_bool(struct uref *, bool *, enum udict_type, char const *);
int uref_attr_get_bool_va(struct uref *, bool *, enum udict_type, char const *, ...);
int uref_attr_set_bool(struct uref *, bool, enum udict_type, char const *);
int uref_attr_set_bool_va(struct uref *, bool, enum udict_type, char const *, ...);
int uref_attr_copy_bool(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_bool_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_small_unsigned(struct uref *, uint8_t *, enum udict_type, char const *);
int uref_attr_get_small_unsigned_va(struct uref *, uint8_t *, enum udict_type, char const *, ...);
int uref_attr_set_small_unsigned(struct uref *, uint8_t, enum udict_type, char const *);
int uref_attr_set_small_unsigned_va(struct uref *, uint8_t, enum udict_type, char const *, ...);
int uref_attr_copy_small_unsigned(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_small_unsigned_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_small_int(struct uref *, int8_t *, enum udict_type, char const *);
int uref_attr_get_small_int_va(struct uref *, int8_t *, enum udict_type, char const *, ...);
int uref_attr_set_small_int(struct uref *, int8_t, enum udict_type, char const *);
int uref_attr_set_small_int_va(struct uref *, int8_t, enum udict_type, char const *, ...);
int uref_attr_copy_small_int(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_small_int_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_unsigned(struct uref *, uint64_t *, enum udict_type, char const *);
int uref_attr_get_unsigned_va(struct uref *, uint64_t *, enum udict_type, char const *, ...);
int uref_attr_set_unsigned(struct uref *, uint64_t, enum udict_type, char const *);
int uref_attr_set_unsigned_va(struct uref *, uint64_t, enum udict_type, char const *, ...);
int uref_attr_copy_unsigned(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_unsigned_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_int(struct uref *, int64_t *, enum udict_type, char const *);
int uref_attr_get_int_va(struct uref *, int64_t *, enum udict_type, char const *, ...);
int uref_attr_set_int(struct uref *, int64_t, enum udict_type, char const *);
int uref_attr_set_int_va(struct uref *, int64_t, enum udict_type, char const *, ...);
int uref_attr_copy_int(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_int_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_float(struct uref *, double *, enum udict_type, char const *);
int uref_attr_get_float_va(struct uref *, double *, enum udict_type, char const *, ...);
int uref_attr_set_float(struct uref *, double, enum udict_type, char const *);
int uref_attr_set_float_va(struct uref *, double, enum udict_type, char const *, ...);
int uref_attr_copy_float(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_float_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_rational(struct uref *, struct urational *, enum udict_type, char const *);
int uref_attr_get_rational_va(struct uref *, struct urational *, enum udict_type, char const *, ...);
int uref_attr_set_rational(struct uref *, struct urational, enum udict_type, char const *);
int uref_attr_set_rational_va(struct uref *, struct urational, enum udict_type, char const *, ...);
int uref_attr_copy_rational(struct uref *, struct uref *, enum udict_type, char const *);
int uref_attr_copy_rational_va(struct uref *, struct uref *, enum udict_type, char const *, ...);
int uref_attr_get_priv(struct uref *, uint64_t *);
void uref_attr_set_priv(struct uref *, uint64_t);
void uref_attr_delete_priv(struct uref *);
void uref_attr_copy_priv(struct uref *, struct uref *);
int uref_attr_match_priv(struct uref *, uint8_t, uint8_t);
int uref_attr_cmp_priv(struct uref *, struct uref *);
int uref_flow_get_end(struct uref *);
void uref_flow_set_end(struct uref *);
void uref_flow_delete_end(struct uref *);
void uref_flow_copy_end(struct uref *, struct uref *);
int uref_flow_get_discontinuity(struct uref *);
void uref_flow_set_discontinuity(struct uref *);
void uref_flow_delete_discontinuity(struct uref *);
void uref_flow_copy_discontinuity(struct uref *, struct uref *);
int uref_flow_get_random(struct uref *);
int uref_flow_set_random(struct uref *);
int uref_flow_delete_random(struct uref *);
int uref_flow_copy_random(struct uref *, struct uref *);
int uref_flow_cmp_random(struct uref *, struct uref *);
int uref_flow_get_error(struct uref *);
int uref_flow_set_error(struct uref *);
int uref_flow_delete_error(struct uref *);
int uref_flow_copy_error(struct uref *, struct uref *);
int uref_flow_cmp_error(struct uref *, struct uref *);
int uref_flow_get_def(struct uref *, char const **);
int uref_flow_set_def(struct uref *, char const *);
int uref_flow_delete_def(struct uref *);
int uref_flow_copy_def(struct uref *, struct uref *);
int uref_flow_match_def(struct uref *, char const *);
int uref_flow_cmp_def(struct uref *, struct uref *);
int uref_flow_get_id(struct uref *, uint64_t *);
int uref_flow_set_id(struct uref *, uint64_t);
int uref_flow_delete_id(struct uref *);
int uref_flow_copy_id(struct uref *, struct uref *);
int uref_flow_match_id(struct uref *, uint64_t, uint64_t);
int uref_flow_cmp_id(struct uref *, struct uref *);
int uref_flow_get_raw_def(struct uref *, char const **);
int uref_flow_set_raw_def(struct uref *, char const *);
int uref_flow_delete_raw_def(struct uref *);
int uref_flow_copy_raw_def(struct uref *, struct uref *);
int uref_flow_match_raw_def(struct uref *, char const *);
int uref_flow_cmp_raw_def(struct uref *, struct uref *);
int uref_flow_get_languages(struct uref *, uint8_t *);
int uref_flow_set_languages(struct uref *, uint8_t);
int uref_flow_delete_languages(struct uref *);
int uref_flow_copy_languages(struct uref *, struct uref *);
int uref_flow_match_languages(struct uref *, uint8_t, uint8_t);
int uref_flow_cmp_languages(struct uref *, struct uref *);
int uref_flow_get_language(struct uref *, char const **, uint8_t);
int uref_flow_set_language(struct uref *, char const *, uint8_t);
int uref_flow_delete_language(struct uref *, uint8_t);
int uref_flow_copy_language(struct uref *, struct uref *, uint8_t);
int uref_flow_match_language(struct uref *, char const *, uint8_t);
int uref_flow_cmp_language(struct uref *, struct uref *, uint8_t);
int uref_flow_get_hearing_impaired(struct uref *, uint8_t);
int uref_flow_set_hearing_impaired(struct uref *, uint8_t);
int uref_flow_delete_hearing_impaired(struct uref *, uint8_t);
int uref_flow_copy_hearing_impaired(struct uref *, struct uref *, uint8_t);
int uref_flow_cmp_hearing_impaired(struct uref *, struct uref *, uint8_t);
int uref_flow_get_visual_impaired(struct uref *, uint8_t);
int uref_flow_set_visual_impaired(struct uref *, uint8_t);
int uref_flow_delete_visual_impaired(struct uref *, uint8_t);
int uref_flow_copy_visual_impaired(struct uref *, struct uref *, uint8_t);
int uref_flow_cmp_visual_impaired(struct uref *, struct uref *, uint8_t);
int uref_flow_get_audio_clean(struct uref *, uint8_t);
int uref_flow_set_audio_clean(struct uref *, uint8_t);
int uref_flow_delete_audio_clean(struct uref *, uint8_t);
int uref_flow_copy_audio_clean(struct uref *, struct uref *, uint8_t);
int uref_flow_cmp_audio_clean(struct uref *, struct uref *, uint8_t);
int uref_flow_get_lowdelay(struct uref *);
int uref_flow_set_lowdelay(struct uref *);
int uref_flow_delete_lowdelay(struct uref *);
int uref_flow_copy_lowdelay(struct uref *, struct uref *);
int uref_flow_cmp_lowdelay(struct uref *, struct uref *);
int uref_flow_get_copyright(struct uref *);
int uref_flow_set_copyright(struct uref *);
int uref_flow_delete_copyright(struct uref *);
int uref_flow_copy_copyright(struct uref *, struct uref *);
int uref_flow_cmp_copyright(struct uref *, struct uref *);
int uref_flow_get_original(struct uref *);
int uref_flow_set_original(struct uref *);
int uref_flow_delete_original(struct uref *);
int uref_flow_copy_original(struct uref *, struct uref *);
int uref_flow_cmp_original(struct uref *, struct uref *);
int uref_flow_get_headers(struct uref *, uint8_t const **, size_t *);
int uref_flow_set_headers(struct uref *, uint8_t const *, size_t);
int uref_flow_delete_headers(struct uref *);
int uref_flow_copy_headers(struct uref *, struct uref *);
int uref_flow_get_name(struct uref *, char const **);
int uref_flow_set_name(struct uref *, char const *);
int uref_flow_delete_name(struct uref *);
int uref_flow_copy_name(struct uref *, struct uref *);
int uref_flow_match_name(struct uref *, char const *);
int uref_flow_cmp_name(struct uref *, struct uref *);
int uref_flow_set_def_va(struct uref *, char const *, ...);
struct ulog {
	enum uprobe_log_level level;
	char const *msg;
	struct uchain prefixes;
};
void ulog_init(struct ulog *, enum uprobe_log_level, char const *);
char const *uprobe_event_str(int);
struct uprobe *uprobe_use(struct uprobe *);
void uprobe_release(struct uprobe *);
bool uprobe_single(struct uprobe *);
bool uprobe_dead(struct uprobe *);
void uprobe_init(struct uprobe *, uprobe_throw_func, struct uprobe *);
void uprobe_clean(struct uprobe *);
int uprobe_throw_va(struct uprobe *, struct upipe *, int, va_list);
int uprobe_throw(struct uprobe *, struct upipe *, int, ...);
int uprobe_throw_next(struct uprobe *, struct upipe *, int, va_list);
void uprobe_log(struct uprobe *, struct upipe *, enum uprobe_log_level, char const *);
void uprobe_log_va(struct uprobe *, struct upipe *, enum uprobe_log_level, char const *, ...);
void uprobe_err_va(struct uprobe *, struct upipe *, char const *, ...);
void uprobe_warn_va(struct uprobe *, struct upipe *, char const *, ...);
void uprobe_notice_va(struct uprobe *, struct upipe *, char const *, ...);
void uprobe_dbg_va(struct uprobe *, struct upipe *, char const *, ...);
void uprobe_verbose_va(struct uprobe *, struct upipe *, char const *, ...);
bool uprobe_plumber(int, va_list, struct uref **, char const **);
void udict_dump(struct udict *, struct uprobe *);
void ufifo_init(struct ufifo *, uint8_t, void *);
void *ufifo_pop_internal(struct ufifo *);
void ufifo_clean(struct ufifo *);
void urequest_init_uref_mgr(struct urequest *, urequest_func, urequest_free_func);
void urequest_init_flow_format(struct urequest *, struct uref *, urequest_func, urequest_free_func);
void urequest_init_ubuf_mgr(struct urequest *, struct uref *, urequest_func, urequest_free_func);
void urequest_init_uclock(struct urequest *, urequest_func, urequest_free_func);
void urequest_init_sink_latency(struct urequest *, urequest_func, urequest_free_func);
void urequest_clean(struct urequest *);
void urequest_free(struct urequest *);
void urequest_set_opaque(struct urequest *, void *);
int urequest_provide_va(struct urequest *, va_list);
int urequest_provide(struct urequest *, ...);
int urequest_provide_uref_mgr(struct urequest *, struct uref_mgr *);
int urequest_provide_flow_format(struct urequest *, struct uref *);
int urequest_provide_ubuf_mgr(struct urequest *, struct ubuf_mgr *, struct uref *);
int urequest_provide_uclock(struct urequest *, struct uclock *);
int urequest_provide_sink_latency(struct urequest *, uint64_t);
struct upipe_mgr *upipe_mgr_use(struct upipe_mgr *);
void upipe_mgr_release(struct upipe_mgr *);
int upipe_mgr_control_va(struct upipe_mgr *, int, va_list);
int upipe_mgr_control(struct upipe_mgr *, int, ...);
int upipe_mgr_vacuum(struct upipe_mgr *);
char const *upipe_err_str(struct upipe *, int);
char const *upipe_command_str(struct upipe *, int);
char const *upipe_event_str(struct upipe *, int);
struct upipe *upipe_alloc_va(struct upipe_mgr *, struct uprobe *, uint32_t, va_list);
struct upipe *upipe_alloc(struct upipe_mgr *, struct uprobe *, uint32_t, ...);
void upipe_init(struct upipe *, struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_use(struct upipe *);
void upipe_release(struct upipe *);
bool upipe_single(struct upipe *);
bool upipe_dead(struct upipe *);
void upipe_set_opaque(struct upipe *, void *);
void upipe_push_probe(struct upipe *, struct uprobe *);
struct uprobe *upipe_pop_probe(struct upipe *);
void upipe_clean(struct upipe *);
int upipe_throw_va(struct upipe *, int, va_list);
int upipe_throw(struct upipe *, int, ...);
void upipe_log_va(struct upipe *, enum uprobe_log_level, char const *, ...);
void upipe_err_va(struct upipe *, char const *, ...);
void upipe_warn_va(struct upipe *, char const *, ...);
void upipe_notice_va(struct upipe *, char const *, ...);
void upipe_dbg_va(struct upipe *, char const *, ...);
void upipe_verbose_va(struct upipe *, char const *, ...);
int upipe_throw_ready(struct upipe *);
int upipe_throw_dead(struct upipe *);
int upipe_throw_source_end(struct upipe *);
int upipe_throw_sink_end(struct upipe *);
int upipe_throw_need_output(struct upipe *, struct uref *);
int upipe_throw_provide_request(struct upipe *, struct urequest *);
int upipe_throw_need_upump_mgr(struct upipe *, struct upump_mgr **);
int upipe_throw_freeze_upump_mgr(struct upipe *);
int upipe_throw_thaw_upump_mgr(struct upipe *);
int upipe_throw_new_flow_def(struct upipe *, struct uref *);
int upipe_throw_new_rap(struct upipe *, struct uref *);
int upipe_split_throw_update(struct upipe *);
int upipe_throw_sync_acquired(struct upipe *);
int upipe_throw_sync_lost(struct upipe *);
int upipe_throw_clock_ref(struct upipe *, struct uref *, uint64_t, int);
int upipe_throw_clock_ts(struct upipe *, struct uref *);
int upipe_throw_clock_utc(struct upipe *, struct uref *, uint64_t);
int upipe_throw_proxy(struct upipe *, struct upipe *, int, va_list);
void upipe_input(struct upipe *, struct uref *, struct upump **);
int upipe_control_va(struct upipe *, int, va_list);
int upipe_control_nodbg(struct upipe *, int, ...);
int upipe_control(struct upipe *, int, ...);
int upipe_get_uri(struct upipe *, char const **);
int upipe_set_uri(struct upipe *, char const *);
int upipe_get_flow_def(struct upipe *, struct uref **);
int upipe_set_flow_def(struct upipe *, struct uref *);
int upipe_get_output(struct upipe *, struct upipe **);
int upipe_set_output(struct upipe *, struct upipe *);
int upipe_get_max_length(struct upipe *, unsigned int *);
int upipe_set_max_length(struct upipe *, unsigned int);
int upipe_get_output_size(struct upipe *, unsigned int *);
int upipe_set_output_size(struct upipe *, unsigned int);
int upipe_get_option(struct upipe *, char const *, char const **);
int upipe_set_option(struct upipe *, char const *, char const *);
int upipe_attach_uref_mgr(struct upipe *);
int upipe_attach_upump_mgr(struct upipe *);
int upipe_attach_uclock(struct upipe *);
int upipe_attach_ubuf_mgr(struct upipe *);
int upipe_register_request(struct upipe *, struct urequest *);
int upipe_unregister_request(struct upipe *, struct urequest *);
int upipe_flush(struct upipe *);
int upipe_sink_flush(struct upipe *);
int upipe_split_iterate(struct upipe *, struct uref **);
int upipe_get_sub_mgr(struct upipe *, struct upipe_mgr **);
int upipe_iterate_sub(struct upipe *, struct upipe **);
int upipe_sub_get_super(struct upipe *, struct upipe **);
int upipe_src_get_size(struct upipe *, uint64_t *);
int upipe_src_get_position(struct upipe *, uint64_t);
int upipe_src_set_position(struct upipe *, uint64_t);
int upipe_src_get_range(struct upipe *, uint64_t *, uint64_t *);
int upipe_src_set_range(struct upipe *, uint64_t, uint64_t);
struct upipe *upipe_void_alloc(struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_void_alloc_output(struct upipe *, struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_void_chain_output(struct upipe *, struct upipe_mgr *, struct uprobe *);
int upipe_void_spawn_output(struct upipe *, struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_void_alloc_input(struct upipe *, struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_void_chain_input(struct upipe *, struct upipe_mgr *, struct uprobe *);
struct upipe *upipe_void_alloc_sub(struct upipe *, struct uprobe *);
struct upipe *upipe_void_chain_sub(struct upipe *, struct uprobe *);
struct upipe *upipe_void_alloc_output_sub(struct upipe *, struct upipe *, struct uprobe *);
struct upipe *upipe_void_chain_output_sub(struct upipe *, struct upipe *, struct uprobe *);
int upipe_void_spawn_output_sub(struct upipe *, struct upipe *, struct uprobe *);
struct upipe *upipe_void_alloc_input_sub(struct upipe *, struct upipe *, struct uprobe *);
struct upipe *upipe_void_chain_input_sub(struct upipe *, struct upipe *, struct uprobe *);
struct upipe *upipe_flow_alloc(struct upipe_mgr *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_alloc_output(struct upipe *, struct upipe_mgr *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_chain_output(struct upipe *, struct upipe_mgr *, struct uprobe *, struct uref *);
int upipe_flow_spawn_output(struct upipe *, struct upipe_mgr *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_alloc_input(struct upipe *, struct upipe_mgr *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_chain_input(struct upipe *, struct upipe_mgr *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_alloc_sub(struct upipe *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_chain_sub(struct upipe *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_alloc_output_sub(struct upipe *, struct upipe *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_chain_output_sub(struct upipe *, struct upipe *, struct uprobe *, struct uref *);
int upipe_flow_spawn_output_sub(struct upipe *, struct upipe *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_alloc_input_sub(struct upipe *, struct upipe *, struct uprobe *, struct uref *);
struct upipe *upipe_flow_chain_input_sub(struct upipe *, struct upipe *, struct uprobe *, struct uref *);
struct upump_blocker *upump_blocker_from_uchain(struct uchain *);
struct uchain *upump_blocker_to_uchain(struct upump_blocker *);
typedef void (*upump_blocker_cb)(struct upump_blocker *);
struct upump_blocker *upump_blocker_alloc(struct upump *, upump_blocker_cb, void *);
void upump_blocker_free(struct upump_blocker *);
void upump_blocker_set_cb(struct upump_blocker *, upump_blocker_cb, void *);
struct upump_blocker *upump_blocker_find(struct uchain *, struct upump *);
int uref_block_flow_get_octetrate(struct uref *, uint64_t *);
int uref_block_flow_set_octetrate(struct uref *, uint64_t);
int uref_block_flow_delete_octetrate(struct uref *);
int uref_block_flow_copy_octetrate(struct uref *, struct uref *);
int uref_block_flow_match_octetrate(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_octetrate(struct uref *, struct uref *);
int uref_block_flow_get_max_octetrate(struct uref *, uint64_t *);
int uref_block_flow_set_max_octetrate(struct uref *, uint64_t);
int uref_block_flow_delete_max_octetrate(struct uref *);
int uref_block_flow_copy_max_octetrate(struct uref *, struct uref *);
int uref_block_flow_match_max_octetrate(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_max_octetrate(struct uref *, struct uref *);
int uref_block_flow_get_buffer_size(struct uref *, uint64_t *);
int uref_block_flow_set_buffer_size(struct uref *, uint64_t);
int uref_block_flow_delete_buffer_size(struct uref *);
int uref_block_flow_copy_buffer_size(struct uref *, struct uref *);
int uref_block_flow_match_buffer_size(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_buffer_size(struct uref *, struct uref *);
int uref_block_flow_get_max_buffer_size(struct uref *, uint64_t *);
int uref_block_flow_set_max_buffer_size(struct uref *, uint64_t);
int uref_block_flow_delete_max_buffer_size(struct uref *);
int uref_block_flow_copy_max_buffer_size(struct uref *, struct uref *);
int uref_block_flow_match_max_buffer_size(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_max_buffer_size(struct uref *, struct uref *);
int uref_block_flow_get_align(struct uref *, uint64_t *);
int uref_block_flow_set_align(struct uref *, uint64_t);
int uref_block_flow_delete_align(struct uref *);
int uref_block_flow_copy_align(struct uref *, struct uref *);
int uref_block_flow_match_align(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_align(struct uref *, struct uref *);
int uref_block_flow_get_align_offset(struct uref *, int64_t *);
int uref_block_flow_set_align_offset(struct uref *, int64_t);
int uref_block_flow_delete_align_offset(struct uref *);
int uref_block_flow_copy_align_offset(struct uref *, struct uref *);
int uref_block_flow_cmp_align_offset(struct uref *, struct uref *);
int uref_block_flow_get_size(struct uref *, uint64_t *);
int uref_block_flow_set_size(struct uref *, uint64_t);
int uref_block_flow_delete_size(struct uref *);
int uref_block_flow_copy_size(struct uref *, struct uref *);
int uref_block_flow_match_size(struct uref *, uint64_t, uint64_t);
int uref_block_flow_cmp_size(struct uref *, struct uref *);
struct uref *uref_block_flow_alloc_def(struct uref_mgr *, char const *);
struct uref *uref_block_flow_alloc_def_va(struct uref_mgr *, char const *, ...);
void uref_block_flow_clear_format(struct uref *);
int uref_block_get_start(struct uref *);
void uref_block_set_start(struct uref *);
void uref_block_delete_start(struct uref *);
void uref_block_copy_start(struct uref *, struct uref *);
int uref_block_get_end(struct uref *);
void uref_block_set_end(struct uref *);
void uref_block_delete_end(struct uref *);
void uref_block_copy_end(struct uref *, struct uref *);
int uref_block_get_header_size(struct uref *, uint64_t *);
int uref_block_set_header_size(struct uref *, uint64_t);
int uref_block_delete_header_size(struct uref *);
int uref_block_copy_header_size(struct uref *, struct uref *);
int uref_block_match_header_size(struct uref *, uint64_t, uint64_t);
int uref_block_cmp_header_size(struct uref *, struct uref *);
struct uref *uref_block_alloc(struct uref_mgr *, struct ubuf_mgr *, int);
int uref_block_size(struct uref *, size_t *);
int uref_block_size_linear(struct uref *, int, size_t *);
int uref_block_read(struct uref *, int, int *, uint8_t const **);
int uref_block_write(struct uref *, int, int *, uint8_t **);
int uref_block_unmap(struct uref *, int);
int uref_block_insert(struct uref *, int, struct ubuf *);
int uref_block_append(struct uref *, struct ubuf *);
int uref_block_delete(struct uref *, int, int);
int uref_block_truncate(struct uref *, int);
int uref_block_resize(struct uref *, int, int);
struct uref *uref_block_splice(struct uref *, int, int);
uint8_t const *uref_block_peek(struct uref *, int, int, uint8_t *);
int uref_block_peek_unmap(struct uref *, int, uint8_t *, uint8_t const *);
int uref_block_extract(struct uref *, int, int, uint8_t *);
int uref_block_iovec_count(struct uref *, int, int);
int uref_block_iovec_read(struct uref *, int, int, struct iovec *);
int uref_block_iovec_unmap(struct uref *, int, int, struct iovec *);
int uref_block_merge(struct uref *, struct ubuf_mgr *, int, int);
int uref_block_compare(struct uref *, int, struct uref *);
int uref_block_equal(struct uref *, struct uref *);
int uref_block_match(struct uref *, uint8_t const *, uint8_t const *, size_t);
int uref_block_scan(struct uref *, size_t *, uint8_t);
int uref_block_find_va(struct uref *, size_t *, unsigned int, va_list);
int uref_block_find(struct uref *, size_t *, unsigned int, ...);
int uref_clock_get_ref(struct uref *);
void uref_clock_set_ref(struct uref *);
void uref_clock_delete_ref(struct uref *);
void uref_clock_copy_ref(struct uref *, struct uref *);
int uref_clock_get_dts_pts_delay(struct uref *, uint64_t *);
void uref_clock_set_dts_pts_delay(struct uref *, uint64_t);
void uref_clock_delete_dts_pts_delay(struct uref *);
void uref_clock_copy_dts_pts_delay(struct uref *, struct uref *);
int uref_clock_match_dts_pts_delay(struct uref *, uint8_t, uint8_t);
int uref_clock_cmp_dts_pts_delay(struct uref *, struct uref *);
int uref_clock_get_cr_dts_delay(struct uref *, uint64_t *);
void uref_clock_set_cr_dts_delay(struct uref *, uint64_t);
void uref_clock_delete_cr_dts_delay(struct uref *);
void uref_clock_copy_cr_dts_delay(struct uref *, struct uref *);
int uref_clock_match_cr_dts_delay(struct uref *, uint8_t, uint8_t);
int uref_clock_cmp_cr_dts_delay(struct uref *, struct uref *);
int uref_clock_get_rap_cr_delay(struct uref *, uint64_t *);
void uref_clock_set_rap_cr_delay(struct uref *, uint64_t);
void uref_clock_delete_rap_cr_delay(struct uref *);
void uref_clock_copy_rap_cr_delay(struct uref *, struct uref *);
int uref_clock_match_rap_cr_delay(struct uref *, uint8_t, uint8_t);
int uref_clock_cmp_rap_cr_delay(struct uref *, struct uref *);
int uref_clock_get_duration(struct uref *, uint64_t *);
int uref_clock_set_duration(struct uref *, uint64_t);
int uref_clock_delete_duration(struct uref *);
int uref_clock_copy_duration(struct uref *, struct uref *);
int uref_clock_match_duration(struct uref *, uint64_t, uint64_t);
int uref_clock_cmp_duration(struct uref *, struct uref *);
int uref_clock_get_index_rap(struct uref *, uint8_t *);
int uref_clock_set_index_rap(struct uref *, uint8_t);
int uref_clock_delete_index_rap(struct uref *);
int uref_clock_copy_index_rap(struct uref *, struct uref *);
int uref_clock_match_index_rap(struct uref *, uint8_t, uint8_t);
int uref_clock_cmp_index_rap(struct uref *, struct uref *);
int uref_clock_get_rate(struct uref *, struct urational *);
int uref_clock_set_rate(struct uref *, struct urational);
int uref_clock_delete_rate(struct uref *);
int uref_clock_copy_rate(struct uref *, struct uref *);
int uref_clock_get_latency(struct uref *, uint64_t *);
int uref_clock_set_latency(struct uref *, uint64_t);
int uref_clock_delete_latency(struct uref *);
int uref_clock_copy_latency(struct uref *, struct uref *);
int uref_clock_match_latency(struct uref *, uint64_t, uint64_t);
int uref_clock_cmp_latency(struct uref *, struct uref *);
void uref_clock_get_date_sys(struct uref const *, uint64_t *, int *);
void uref_clock_set_date_sys(struct uref *, uint64_t, int);
void uref_clock_delete_date_sys(struct uref *);
void uref_clock_get_date_prog(struct uref const *, uint64_t *, int *);
void uref_clock_set_date_prog(struct uref *, uint64_t, int);
void uref_clock_delete_date_prog(struct uref *);
void uref_clock_get_date_orig(struct uref const *, uint64_t *, int *);
void uref_clock_set_date_orig(struct uref *, uint64_t, int);
void uref_clock_delete_date_orig(struct uref *);
void uref_clock_set_cr_sys(struct uref *, uint64_t);
void uref_clock_set_cr_prog(struct uref *, uint64_t);
void uref_clock_set_cr_orig(struct uref *, uint64_t);
void uref_clock_set_dts_sys(struct uref *, uint64_t);
void uref_clock_set_dts_prog(struct uref *, uint64_t);
void uref_clock_set_dts_orig(struct uref *, uint64_t);
void uref_clock_set_pts_sys(struct uref *, uint64_t);
void uref_clock_set_pts_prog(struct uref *, uint64_t);
void uref_clock_set_pts_orig(struct uref *, uint64_t);
int uref_clock_get_pts_sys(struct uref *, uint64_t *);
int uref_clock_get_pts_prog(struct uref *, uint64_t *);
int uref_clock_get_pts_orig(struct uref *, uint64_t *);
int uref_clock_get_dts_sys(struct uref *, uint64_t *);
int uref_clock_get_dts_prog(struct uref *, uint64_t *);
int uref_clock_get_dts_orig(struct uref *, uint64_t *);
int uref_clock_get_cr_sys(struct uref *, uint64_t *);
int uref_clock_get_cr_prog(struct uref *, uint64_t *);
int uref_clock_get_cr_orig(struct uref *, uint64_t *);
int uref_clock_get_rap_sys(struct uref *, uint64_t *);
int uref_clock_get_rap_prog(struct uref *, uint64_t *);
int uref_clock_get_rap_orig(struct uref *, uint64_t *);
int uref_clock_set_rap_sys(struct uref *, uint64_t);
int uref_clock_set_rap_prog(struct uref *, uint64_t);
int uref_clock_set_rap_orig(struct uref *, uint64_t);
int uref_clock_rebase_cr_sys(struct uref *);
int uref_clock_rebase_cr_prog(struct uref *);
int uref_clock_rebase_cr_orig(struct uref *);
int uref_clock_rebase_dts_sys(struct uref *);
int uref_clock_rebase_dts_prog(struct uref *);
int uref_clock_rebase_dts_orig(struct uref *);
int uref_clock_rebase_pts_sys(struct uref *);
int uref_clock_rebase_pts_prog(struct uref *);
int uref_clock_rebase_pts_orig(struct uref *);
struct uqueue {
	struct ufifo fifo;
	uatomic_uint32_t counter;
	uint32_t length;
	struct ueventfd event_push;
	struct ueventfd event_pop;
};
bool uqueue_init(struct uqueue *, uint8_t, void *);
struct upump *uqueue_upump_alloc_push(struct uqueue *, struct upump_mgr *, upump_cb, void *);
struct upump *uqueue_upump_alloc_pop(struct uqueue *, struct upump_mgr *, upump_cb, void *);
bool uqueue_push(struct uqueue *, void *);
void *uqueue_pop_internal(struct uqueue *);
unsigned int uqueue_length(struct uqueue *);
void uqueue_clean(struct uqueue *);
void uref_dump(struct uref *, struct uprobe *);
int uref_event_get_events(struct uref *, uint64_t *);
int uref_event_set_events(struct uref *, uint64_t);
int uref_event_delete_events(struct uref *);
int uref_event_copy_events(struct uref *, struct uref *);
int uref_event_match_events(struct uref *, uint64_t, uint64_t);
int uref_event_cmp_events(struct uref *, struct uref *);
int uref_event_get_id(struct uref *, uint64_t *, uint64_t);
int uref_event_set_id(struct uref *, uint64_t, uint64_t);
int uref_event_delete_id(struct uref *, uint64_t);
int uref_event_copy_id(struct uref *, struct uref *, uint64_t);
int uref_event_match_id(struct uref *, uint8_t, uint8_t, uint64_t);
int uref_event_cmp_id(struct uref *, struct uref *, uint64_t);
int uref_event_get_start(struct uref *, uint64_t *, uint64_t);
int uref_event_set_start(struct uref *, uint64_t, uint64_t);
int uref_event_delete_start(struct uref *, uint64_t);
int uref_event_copy_start(struct uref *, struct uref *, uint64_t);
int uref_event_match_start(struct uref *, uint8_t, uint8_t, uint64_t);
int uref_event_cmp_start(struct uref *, struct uref *, uint64_t);
int uref_event_get_duration(struct uref *, uint64_t *, uint64_t);
int uref_event_set_duration(struct uref *, uint64_t, uint64_t);
int uref_event_delete_duration(struct uref *, uint64_t);
int uref_event_copy_duration(struct uref *, struct uref *, uint64_t);
int uref_event_match_duration(struct uref *, uint8_t, uint8_t, uint64_t);
int uref_event_cmp_duration(struct uref *, struct uref *, uint64_t);
int uref_event_get_language(struct uref *, char const **, uint64_t);
int uref_event_set_language(struct uref *, char const *, uint64_t);
int uref_event_delete_language(struct uref *, uint64_t);
int uref_event_copy_language(struct uref *, struct uref *, uint64_t);
int uref_event_match_language(struct uref *, char const *, uint64_t);
int uref_event_cmp_language(struct uref *, struct uref *, uint64_t);
int uref_event_get_name(struct uref *, char const **, uint64_t);
int uref_event_set_name(struct uref *, char const *, uint64_t);
int uref_event_delete_name(struct uref *, uint64_t);
int uref_event_copy_name(struct uref *, struct uref *, uint64_t);
int uref_event_match_name(struct uref *, char const *, uint64_t);
int uref_event_cmp_name(struct uref *, struct uref *, uint64_t);
int uref_event_get_description(struct uref *, char const **, uint64_t);
int uref_event_set_description(struct uref *, char const *, uint64_t);
int uref_event_delete_description(struct uref *, uint64_t);
int uref_event_copy_description(struct uref *, struct uref *, uint64_t);
int uref_event_match_description(struct uref *, char const *, uint64_t);
int uref_event_cmp_description(struct uref *, struct uref *, uint64_t);
int uref_m3u_flow_get_version(struct uref *, uint8_t *);
int uref_m3u_flow_set_version(struct uref *, uint8_t);
int uref_m3u_flow_delete_version(struct uref *);
int uref_m3u_flow_copy_version(struct uref *, struct uref *);
int uref_m3u_flow_match_version(struct uref *, uint8_t, uint8_t);
int uref_m3u_flow_cmp_version(struct uref *, struct uref *);
int uref_m3u_get_uri(struct uref *, char const **);
int uref_m3u_set_uri(struct uref *, char const *);
int uref_m3u_delete_uri(struct uref *);
int uref_m3u_copy_uri(struct uref *, struct uref *);
int uref_m3u_match_uri(struct uref *, char const *);
int uref_m3u_cmp_uri(struct uref *, struct uref *);
int uref_m3u_master_get_stream_inf(struct uref *, char const **);
int uref_m3u_master_set_stream_inf(struct uref *, char const *);
int uref_m3u_master_delete_stream_inf(struct uref *);
int uref_m3u_master_copy_stream_inf(struct uref *, struct uref *);
int uref_m3u_master_match_stream_inf(struct uref *, char const *);
int uref_m3u_master_cmp_stream_inf(struct uref *, struct uref *);
int uref_m3u_master_get_bandwidth(struct uref *, uint64_t *);
int uref_m3u_master_set_bandwidth(struct uref *, uint64_t);
int uref_m3u_master_delete_bandwidth(struct uref *);
int uref_m3u_master_copy_bandwidth(struct uref *, struct uref *);
int uref_m3u_master_match_bandwidth(struct uref *, uint64_t, uint64_t);
int uref_m3u_master_cmp_bandwidth(struct uref *, struct uref *);
int uref_m3u_master_get_codecs(struct uref *, char const **);
int uref_m3u_master_set_codecs(struct uref *, char const *);
int uref_m3u_master_delete_codecs(struct uref *);
int uref_m3u_master_copy_codecs(struct uref *, struct uref *);
int uref_m3u_master_match_codecs(struct uref *, char const *);
int uref_m3u_master_cmp_codecs(struct uref *, struct uref *);
int uref_m3u_playlist_flow_get_type(struct uref *, char const **);
int uref_m3u_playlist_flow_set_type(struct uref *, char const *);
int uref_m3u_playlist_flow_delete_type(struct uref *);
int uref_m3u_playlist_flow_copy_type(struct uref *, struct uref *);
int uref_m3u_playlist_flow_match_type(struct uref *, char const *);
int uref_m3u_playlist_flow_cmp_type(struct uref *, struct uref *);
int uref_m3u_playlist_flow_get_target_duration(struct uref *, uint64_t *);
int uref_m3u_playlist_flow_set_target_duration(struct uref *, uint64_t);
int uref_m3u_playlist_flow_delete_target_duration(struct uref *);
int uref_m3u_playlist_flow_copy_target_duration(struct uref *, struct uref *);
int uref_m3u_playlist_flow_match_target_duration(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_flow_cmp_target_duration(struct uref *, struct uref *);
int uref_m3u_playlist_flow_get_media_sequence(struct uref *, uint64_t *);
int uref_m3u_playlist_flow_set_media_sequence(struct uref *, uint64_t);
int uref_m3u_playlist_flow_delete_media_sequence(struct uref *);
int uref_m3u_playlist_flow_copy_media_sequence(struct uref *, struct uref *);
int uref_m3u_playlist_flow_match_media_sequence(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_flow_cmp_media_sequence(struct uref *, struct uref *);
int uref_m3u_playlist_flow_get_endlist(struct uref *);
int uref_m3u_playlist_flow_set_endlist(struct uref *);
int uref_m3u_playlist_flow_delete_endlist(struct uref *);
int uref_m3u_playlist_flow_copy_endlist(struct uref *, struct uref *);
int uref_m3u_playlist_flow_cmp_endlist(struct uref *, struct uref *);
int uref_m3u_playlist_get_seq_duration(struct uref *, uint64_t *);
int uref_m3u_playlist_set_seq_duration(struct uref *, uint64_t);
int uref_m3u_playlist_delete_seq_duration(struct uref *);
int uref_m3u_playlist_copy_seq_duration(struct uref *, struct uref *);
int uref_m3u_playlist_match_seq_duration(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_cmp_seq_duration(struct uref *, struct uref *);
int uref_m3u_playlist_get_seq_time(struct uref *, uint64_t *);
int uref_m3u_playlist_set_seq_time(struct uref *, uint64_t);
int uref_m3u_playlist_delete_seq_time(struct uref *);
int uref_m3u_playlist_copy_seq_time(struct uref *, struct uref *);
int uref_m3u_playlist_match_seq_time(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_cmp_seq_time(struct uref *, struct uref *);
int uref_m3u_playlist_get_byte_range_len(struct uref *, uint64_t *);
int uref_m3u_playlist_set_byte_range_len(struct uref *, uint64_t);
int uref_m3u_playlist_delete_byte_range_len(struct uref *);
int uref_m3u_playlist_copy_byte_range_len(struct uref *, struct uref *);
int uref_m3u_playlist_match_byte_range_len(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_cmp_byte_range_len(struct uref *, struct uref *);
int uref_m3u_playlist_get_byte_range_off(struct uref *, uint64_t *);
int uref_m3u_playlist_set_byte_range_off(struct uref *, uint64_t);
int uref_m3u_playlist_delete_byte_range_off(struct uref *);
int uref_m3u_playlist_copy_byte_range_off(struct uref *, struct uref *);
int uref_m3u_playlist_match_byte_range_off(struct uref *, uint64_t, uint64_t);
int uref_m3u_playlist_cmp_byte_range_off(struct uref *, struct uref *);
int uref_pic_flow_get_macropixel(struct uref *, uint8_t *);
int uref_pic_flow_set_macropixel(struct uref *, uint8_t);
int uref_pic_flow_delete_macropixel(struct uref *);
int uref_pic_flow_copy_macropixel(struct uref *, struct uref *);
int uref_pic_flow_match_macropixel(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_macropixel(struct uref *, struct uref *);
int uref_pic_flow_get_planes(struct uref *, uint8_t *);
int uref_pic_flow_set_planes(struct uref *, uint8_t);
int uref_pic_flow_delete_planes(struct uref *);
int uref_pic_flow_copy_planes(struct uref *, struct uref *);
int uref_pic_flow_match_planes(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_planes(struct uref *, struct uref *);
int uref_pic_flow_get_hsubsampling(struct uref *, uint8_t *, uint8_t);
int uref_pic_flow_set_hsubsampling(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_delete_hsubsampling(struct uref *, uint8_t);
int uref_pic_flow_copy_hsubsampling(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_match_hsubsampling(struct uref *, uint8_t, uint8_t, uint8_t);
int uref_pic_flow_cmp_hsubsampling(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_get_vsubsampling(struct uref *, uint8_t *, uint8_t);
int uref_pic_flow_set_vsubsampling(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_delete_vsubsampling(struct uref *, uint8_t);
int uref_pic_flow_copy_vsubsampling(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_match_vsubsampling(struct uref *, uint8_t, uint8_t, uint8_t);
int uref_pic_flow_cmp_vsubsampling(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_get_macropixel_size(struct uref *, uint8_t *, uint8_t);
int uref_pic_flow_set_macropixel_size(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_delete_macropixel_size(struct uref *, uint8_t);
int uref_pic_flow_copy_macropixel_size(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_match_macropixel_size(struct uref *, uint8_t, uint8_t, uint8_t);
int uref_pic_flow_cmp_macropixel_size(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_get_chroma(struct uref *, char const **, uint8_t);
int uref_pic_flow_set_chroma(struct uref *, char const *, uint8_t);
int uref_pic_flow_delete_chroma(struct uref *, uint8_t);
int uref_pic_flow_copy_chroma(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_match_chroma(struct uref *, char const *, uint8_t);
int uref_pic_flow_cmp_chroma(struct uref *, struct uref *, uint8_t);
int uref_pic_flow_get_fps(struct uref *, struct urational *);
int uref_pic_flow_set_fps(struct uref *, struct urational);
int uref_pic_flow_delete_fps(struct uref *);
int uref_pic_flow_copy_fps(struct uref *, struct uref *);
int uref_pic_flow_get_hmprepend(struct uref *, uint8_t *);
int uref_pic_flow_set_hmprepend(struct uref *, uint8_t);
int uref_pic_flow_delete_hmprepend(struct uref *);
int uref_pic_flow_copy_hmprepend(struct uref *, struct uref *);
int uref_pic_flow_match_hmprepend(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_hmprepend(struct uref *, struct uref *);
int uref_pic_flow_get_hmappend(struct uref *, uint8_t *);
int uref_pic_flow_set_hmappend(struct uref *, uint8_t);
int uref_pic_flow_delete_hmappend(struct uref *);
int uref_pic_flow_copy_hmappend(struct uref *, struct uref *);
int uref_pic_flow_match_hmappend(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_hmappend(struct uref *, struct uref *);
int uref_pic_flow_get_vprepend(struct uref *, uint8_t *);
int uref_pic_flow_set_vprepend(struct uref *, uint8_t);
int uref_pic_flow_delete_vprepend(struct uref *);
int uref_pic_flow_copy_vprepend(struct uref *, struct uref *);
int uref_pic_flow_match_vprepend(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_vprepend(struct uref *, struct uref *);
int uref_pic_flow_get_vappend(struct uref *, uint8_t *);
int uref_pic_flow_set_vappend(struct uref *, uint8_t);
int uref_pic_flow_delete_vappend(struct uref *);
int uref_pic_flow_copy_vappend(struct uref *, struct uref *);
int uref_pic_flow_match_vappend(struct uref *, uint8_t, uint8_t);
int uref_pic_flow_cmp_vappend(struct uref *, struct uref *);
int uref_pic_flow_get_align(struct uref *, uint64_t *);
int uref_pic_flow_set_align(struct uref *, uint64_t);
int uref_pic_flow_delete_align(struct uref *);
int uref_pic_flow_copy_align(struct uref *, struct uref *);
int uref_pic_flow_match_align(struct uref *, uint64_t, uint64_t);
int uref_pic_flow_cmp_align(struct uref *, struct uref *);
int uref_pic_flow_get_align_hmoffset(struct uref *, int64_t *);
int uref_pic_flow_set_align_hmoffset(struct uref *, int64_t);
int uref_pic_flow_delete_align_hmoffset(struct uref *);
int uref_pic_flow_copy_align_hmoffset(struct uref *, struct uref *);
int uref_pic_flow_cmp_align_hmoffset(struct uref *, struct uref *);
int uref_pic_flow_get_sar(struct uref *, struct urational *);
int uref_pic_flow_set_sar(struct uref *, struct urational);
int uref_pic_flow_delete_sar(struct uref *);
int uref_pic_flow_copy_sar(struct uref *, struct uref *);
int uref_pic_flow_get_overscan(struct uref *);
int uref_pic_flow_set_overscan(struct uref *);
int uref_pic_flow_delete_overscan(struct uref *);
int uref_pic_flow_copy_overscan(struct uref *, struct uref *);
int uref_pic_flow_cmp_overscan(struct uref *, struct uref *);
int uref_pic_flow_get_dar(struct uref *, struct urational *);
int uref_pic_flow_set_dar(struct uref *, struct urational);
int uref_pic_flow_delete_dar(struct uref *);
int uref_pic_flow_copy_dar(struct uref *, struct uref *);
int uref_pic_flow_get_hsize(struct uref *, uint64_t *);
int uref_pic_flow_set_hsize(struct uref *, uint64_t);
int uref_pic_flow_delete_hsize(struct uref *);
int uref_pic_flow_copy_hsize(struct uref *, struct uref *);
int uref_pic_flow_match_hsize(struct uref *, uint64_t, uint64_t);
int uref_pic_flow_cmp_hsize(struct uref *, struct uref *);
int uref_pic_flow_get_vsize(struct uref *, uint64_t *);
int uref_pic_flow_set_vsize(struct uref *, uint64_t);
int uref_pic_flow_delete_vsize(struct uref *);
int uref_pic_flow_copy_vsize(struct uref *, struct uref *);
int uref_pic_flow_match_vsize(struct uref *, uint64_t, uint64_t);
int uref_pic_flow_cmp_vsize(struct uref *, struct uref *);
int uref_pic_flow_get_hsize_visible(struct uref *, uint64_t *);
int uref_pic_flow_set_hsize_visible(struct uref *, uint64_t);
int uref_pic_flow_delete_hsize_visible(struct uref *);
int uref_pic_flow_copy_hsize_visible(struct uref *, struct uref *);
int uref_pic_flow_match_hsize_visible(struct uref *, uint64_t, uint64_t);
int uref_pic_flow_cmp_hsize_visible(struct uref *, struct uref *);
int uref_pic_flow_get_vsize_visible(struct uref *, uint64_t *);
int uref_pic_flow_set_vsize_visible(struct uref *, uint64_t);
int uref_pic_flow_delete_vsize_visible(struct uref *);
int uref_pic_flow_copy_vsize_visible(struct uref *, struct uref *);
int uref_pic_flow_match_vsize_visible(struct uref *, uint64_t, uint64_t);
int uref_pic_flow_cmp_vsize_visible(struct uref *, struct uref *);
int uref_pic_flow_get_video_format(struct uref *, char const **);
int uref_pic_flow_set_video_format(struct uref *, char const *);
int uref_pic_flow_delete_video_format(struct uref *);
int uref_pic_flow_copy_video_format(struct uref *, struct uref *);
int uref_pic_flow_match_video_format(struct uref *, char const *);
int uref_pic_flow_cmp_video_format(struct uref *, struct uref *);
int uref_pic_flow_get_full_range(struct uref *);
int uref_pic_flow_set_full_range(struct uref *);
int uref_pic_flow_delete_full_range(struct uref *);
int uref_pic_flow_copy_full_range(struct uref *, struct uref *);
int uref_pic_flow_cmp_full_range(struct uref *, struct uref *);
int uref_pic_flow_get_colour_primaries(struct uref *, char const **);
int uref_pic_flow_set_colour_primaries(struct uref *, char const *);
int uref_pic_flow_delete_colour_primaries(struct uref *);
int uref_pic_flow_copy_colour_primaries(struct uref *, struct uref *);
int uref_pic_flow_match_colour_primaries(struct uref *, char const *);
int uref_pic_flow_cmp_colour_primaries(struct uref *, struct uref *);
int uref_pic_flow_get_transfer_characteristics(struct uref *, char const **);
int uref_pic_flow_set_transfer_characteristics(struct uref *, char const *);
int uref_pic_flow_delete_transfer_characteristics(struct uref *);
int uref_pic_flow_copy_transfer_characteristics(struct uref *, struct uref *);
int uref_pic_flow_match_transfer_characteristics(struct uref *, char const *);
int uref_pic_flow_cmp_transfer_characteristics(struct uref *, struct uref *);
int uref_pic_flow_get_matrix_coefficients(struct uref *, char const **);
int uref_pic_flow_set_matrix_coefficients(struct uref *, char const *);
int uref_pic_flow_delete_matrix_coefficients(struct uref *);
int uref_pic_flow_copy_matrix_coefficients(struct uref *, struct uref *);
int uref_pic_flow_match_matrix_coefficients(struct uref *, char const *);
int uref_pic_flow_cmp_matrix_coefficients(struct uref *, struct uref *);
struct uref *uref_pic_flow_alloc_def(struct uref_mgr *, uint8_t);
int uref_pic_flow_add_plane(struct uref *, uint8_t, uint8_t, uint8_t, char const *);
int uref_pic_flow_find_chroma(struct uref *, char const *, uint8_t *);
int uref_pic_flow_check_chroma(struct uref *, uint8_t, uint8_t, uint8_t, char const *);
int uref_pic_flow_copy_format(struct uref *, struct uref *);
int uref_pic_flow_max_subsampling(struct uref *, uint8_t *, uint8_t *);
void uref_pic_flow_clear_format(struct uref *);
bool uref_pic_flow_compare_format(struct uref *, struct uref *);
int uref_pic_flow_infer_sar(struct uref *, struct urational);
int uref_pic_get_number(struct uref *, uint64_t *);
int uref_pic_set_number(struct uref *, uint64_t);
int uref_pic_delete_number(struct uref *);
int uref_pic_copy_number(struct uref *, struct uref *);
int uref_pic_match_number(struct uref *, uint64_t, uint64_t);
int uref_pic_cmp_number(struct uref *, struct uref *);
int uref_pic_get_key(struct uref *);
int uref_pic_set_key(struct uref *);
int uref_pic_delete_key(struct uref *);
int uref_pic_copy_key(struct uref *, struct uref *);
int uref_pic_cmp_key(struct uref *, struct uref *);
int uref_pic_get_hposition(struct uref *, uint64_t *);
int uref_pic_set_hposition(struct uref *, uint64_t);
int uref_pic_delete_hposition(struct uref *);
int uref_pic_copy_hposition(struct uref *, struct uref *);
int uref_pic_match_hposition(struct uref *, uint64_t, uint64_t);
int uref_pic_cmp_hposition(struct uref *, struct uref *);
int uref_pic_get_vposition(struct uref *, uint64_t *);
int uref_pic_set_vposition(struct uref *, uint64_t);
int uref_pic_delete_vposition(struct uref *);
int uref_pic_copy_vposition(struct uref *, struct uref *);
int uref_pic_match_vposition(struct uref *, uint64_t, uint64_t);
int uref_pic_cmp_vposition(struct uref *, struct uref *);
int uref_pic_get_progressive(struct uref *);
int uref_pic_set_progressive(struct uref *);
int uref_pic_delete_progressive(struct uref *);
int uref_pic_copy_progressive(struct uref *, struct uref *);
int uref_pic_cmp_progressive(struct uref *, struct uref *);
int uref_pic_get_tf(struct uref *);
int uref_pic_set_tf(struct uref *);
int uref_pic_delete_tf(struct uref *);
int uref_pic_copy_tf(struct uref *, struct uref *);
int uref_pic_cmp_tf(struct uref *, struct uref *);
int uref_pic_get_bf(struct uref *);
int uref_pic_set_bf(struct uref *);
int uref_pic_delete_bf(struct uref *);
int uref_pic_copy_bf(struct uref *, struct uref *);
int uref_pic_cmp_bf(struct uref *, struct uref *);
int uref_pic_get_tff(struct uref *);
int uref_pic_set_tff(struct uref *);
int uref_pic_delete_tff(struct uref *);
int uref_pic_copy_tff(struct uref *, struct uref *);
int uref_pic_cmp_tff(struct uref *, struct uref *);
int uref_pic_get_afd(struct uref *, uint8_t *);
int uref_pic_set_afd(struct uref *, uint8_t);
int uref_pic_delete_afd(struct uref *);
int uref_pic_copy_afd(struct uref *, struct uref *);
int uref_pic_match_afd(struct uref *, uint8_t, uint8_t);
int uref_pic_cmp_afd(struct uref *, struct uref *);
int uref_pic_get_cea_708(struct uref *, uint8_t const **, size_t *);
int uref_pic_set_cea_708(struct uref *, uint8_t const *, size_t);
int uref_pic_delete_cea_708(struct uref *);
int uref_pic_copy_cea_708(struct uref *, struct uref *);
struct uref *uref_pic_alloc(struct uref_mgr *, struct ubuf_mgr *, int, int);
int uref_pic_size(struct uref *, size_t *, size_t *, uint8_t *);
int uref_pic_plane_iterate(struct uref *, char const **);
int uref_pic_plane_size(struct uref *, char const *, size_t *, uint8_t *, uint8_t *, uint8_t *);
int uref_pic_plane_read(struct uref *, char const *, int, int, int, int, uint8_t const **);
int uref_pic_plane_write(struct uref *, char const *, int, int, int, int, uint8_t **);
int uref_pic_plane_unmap(struct uref *, char const *, int, int, int, int);
int uref_pic_plane_clear(struct uref *, char const *, int, int, int, int, int);
int uref_pic_resize(struct uref *, int, int, int, int);
int uref_pic_clear(struct uref *, int, int, int, int, int);
int uref_pic_blit(struct uref *, struct ubuf *, int, int, int, int, int, int);
int uref_pic_replace(struct uref *, struct ubuf_mgr *, int, int, int, int);
int uref_program_flow_get_name(struct uref *, char const **);
int uref_program_flow_set_name(struct uref *, char const *);
int uref_program_flow_delete_name(struct uref *);
int uref_program_flow_copy_name(struct uref *, struct uref *);
int uref_program_flow_match_name(struct uref *, char const *);
int uref_program_flow_cmp_name(struct uref *, struct uref *);
struct uref *uref_program_flow_alloc_def(struct uref_mgr *);
int uref_sound_flow_get_planes(struct uref *, uint8_t *);
int uref_sound_flow_set_planes(struct uref *, uint8_t);
int uref_sound_flow_delete_planes(struct uref *);
int uref_sound_flow_copy_planes(struct uref *, struct uref *);
int uref_sound_flow_match_planes(struct uref *, uint8_t, uint8_t);
int uref_sound_flow_cmp_planes(struct uref *, struct uref *);
int uref_sound_flow_get_channel(struct uref *, char const **, uint8_t);
int uref_sound_flow_set_channel(struct uref *, char const *, uint8_t);
int uref_sound_flow_delete_channel(struct uref *, uint8_t);
int uref_sound_flow_copy_channel(struct uref *, struct uref *, uint8_t);
int uref_sound_flow_match_channel(struct uref *, char const *, uint8_t);
int uref_sound_flow_cmp_channel(struct uref *, struct uref *, uint8_t);
int uref_sound_flow_get_channels(struct uref *, uint8_t *);
int uref_sound_flow_set_channels(struct uref *, uint8_t);
int uref_sound_flow_delete_channels(struct uref *);
int uref_sound_flow_copy_channels(struct uref *, struct uref *);
int uref_sound_flow_match_channels(struct uref *, uint8_t, uint8_t);
int uref_sound_flow_cmp_channels(struct uref *, struct uref *);
int uref_sound_flow_get_sample_size(struct uref *, uint8_t *);
int uref_sound_flow_set_sample_size(struct uref *, uint8_t);
int uref_sound_flow_delete_sample_size(struct uref *);
int uref_sound_flow_copy_sample_size(struct uref *, struct uref *);
int uref_sound_flow_match_sample_size(struct uref *, uint8_t, uint8_t);
int uref_sound_flow_cmp_sample_size(struct uref *, struct uref *);
int uref_sound_flow_get_rate(struct uref *, uint64_t *);
int uref_sound_flow_set_rate(struct uref *, uint64_t);
int uref_sound_flow_delete_rate(struct uref *);
int uref_sound_flow_copy_rate(struct uref *, struct uref *);
int uref_sound_flow_match_rate(struct uref *, uint64_t, uint64_t);
int uref_sound_flow_cmp_rate(struct uref *, struct uref *);
int uref_sound_flow_get_samples(struct uref *, uint64_t *);
int uref_sound_flow_set_samples(struct uref *, uint64_t);
int uref_sound_flow_delete_samples(struct uref *);
int uref_sound_flow_copy_samples(struct uref *, struct uref *);
int uref_sound_flow_match_samples(struct uref *, uint64_t, uint64_t);
int uref_sound_flow_cmp_samples(struct uref *, struct uref *);
int uref_sound_flow_get_align(struct uref *, uint64_t *);
int uref_sound_flow_set_align(struct uref *, uint64_t);
int uref_sound_flow_delete_align(struct uref *);
int uref_sound_flow_copy_align(struct uref *, struct uref *);
int uref_sound_flow_match_align(struct uref *, uint64_t, uint64_t);
int uref_sound_flow_cmp_align(struct uref *, struct uref *);
struct uref *uref_sound_flow_alloc_def(struct uref_mgr *, char const *, uint8_t, uint8_t);
int uref_sound_flow_add_plane(struct uref *, char const *);
int uref_sound_flow_find_channel(struct uref *, char const *, uint8_t *);
int uref_sound_flow_check_channel(struct uref *, char const *);
int uref_sound_flow_copy_format(struct uref *, struct uref *);
void uref_sound_flow_clear_format(struct uref *);
bool uref_sound_flow_compare_format(struct uref *, struct uref *);
struct uref *uref_sound_alloc(struct uref_mgr *, struct ubuf_mgr *, int);
int uref_sound_size(struct uref *, size_t *, uint8_t *);
int uref_sound_plane_iterate(struct uref *, char const **);
int uref_sound_plane_unmap(struct uref *, char const *, int, int);
int uref_sound_unmap(struct uref *, int, int, uint8_t);
int uref_sound_plane_read_void(struct uref *, char const *, int, int, void const **);
int uref_sound_plane_write_void(struct uref *, char const *, int, int, void **);
int uref_sound_read_void(struct uref *, int, int, void const **, uint8_t);
int uref_sound_write_void(struct uref *, int, int, void **, uint8_t);
int uref_sound_plane_read_uint8_t(struct uref *, char const *, int, int, uint8_t const **);
int uref_sound_plane_write_uint8_t(struct uref *, char const *, int, int, uint8_t **);
int uref_sound_read_uint8_t(struct uref *, int, int, uint8_t const **, uint8_t);
int uref_sound_write_uint8_t(struct uref *, int, int, uint8_t **, uint8_t);
int uref_sound_plane_read_int16_t(struct uref *, char const *, int, int, int16_t const **);
int uref_sound_plane_write_int16_t(struct uref *, char const *, int, int, int16_t **);
int uref_sound_read_int16_t(struct uref *, int, int, int16_t const **, uint8_t);
int uref_sound_write_int16_t(struct uref *, int, int, int16_t **, uint8_t);
int uref_sound_plane_read_int32_t(struct uref *, char const *, int, int, int32_t const **);
int uref_sound_plane_write_int32_t(struct uref *, char const *, int, int, int32_t **);
int uref_sound_read_int32_t(struct uref *, int, int, int32_t const **, uint8_t);
int uref_sound_write_int32_t(struct uref *, int, int, int32_t **, uint8_t);
int uref_sound_plane_read_float(struct uref *, char const *, int, int, float const **);
int uref_sound_plane_write_float(struct uref *, char const *, int, int, float **);
int uref_sound_read_float(struct uref *, int, int, float const **, uint8_t);
int uref_sound_write_float(struct uref *, int, int, float **, uint8_t);
int uref_sound_plane_read_double(struct uref *, char const *, int, int, double const **);
int uref_sound_plane_write_double(struct uref *, char const *, int, int, double **);
int uref_sound_read_double(struct uref *, int, int, double const **, uint8_t);
int uref_sound_write_double(struct uref *, int, int, double **, uint8_t);
int uref_sound_resize(struct uref *, int, int);
int uref_sound_interleave(struct uref *, uint8_t *, int, int, uint8_t, uint8_t);
int uref_sound_replace(struct uref *, struct ubuf_mgr *, int, int);
ssize_t uuri_escape_len(char const *);
ssize_t uuri_unescape_len(char const *);
struct uuri_authority uuri_authority_null(void);
bool uuri_authority_is_null(struct uuri_authority);
struct uuri uuri_null(void);
bool uuri_is_null(struct uuri);
int uuri_from_str(struct uuri *, char const *);
int uref_uri_get_scheme(struct uref *, char const **);
int uref_uri_set_scheme(struct uref *, char const *);
int uref_uri_delete_scheme(struct uref *);
int uref_uri_copy_scheme(struct uref *, struct uref *);
int uref_uri_match_scheme(struct uref *, char const *);
int uref_uri_cmp_scheme(struct uref *, struct uref *);
int uref_uri_get_userinfo(struct uref *, char const **);
int uref_uri_set_userinfo(struct uref *, char const *);
int uref_uri_delete_userinfo(struct uref *);
int uref_uri_copy_userinfo(struct uref *, struct uref *);
int uref_uri_match_userinfo(struct uref *, char const *);
int uref_uri_cmp_userinfo(struct uref *, struct uref *);
int uref_uri_get_host(struct uref *, char const **);
int uref_uri_set_host(struct uref *, char const *);
int uref_uri_delete_host(struct uref *);
int uref_uri_copy_host(struct uref *, struct uref *);
int uref_uri_match_host(struct uref *, char const *);
int uref_uri_cmp_host(struct uref *, struct uref *);
int uref_uri_get_port(struct uref *, char const **);
int uref_uri_set_port(struct uref *, char const *);
int uref_uri_delete_port(struct uref *);
int uref_uri_copy_port(struct uref *, struct uref *);
int uref_uri_match_port(struct uref *, char const *);
int uref_uri_cmp_port(struct uref *, struct uref *);
int uref_uri_get_path(struct uref *, char const **);
int uref_uri_set_path(struct uref *, char const *);
int uref_uri_delete_path(struct uref *);
int uref_uri_copy_path(struct uref *, struct uref *);
int uref_uri_match_path(struct uref *, char const *);
int uref_uri_cmp_path(struct uref *, struct uref *);
int uref_uri_get_query(struct uref *, char const **);
int uref_uri_set_query(struct uref *, char const *);
int uref_uri_delete_query(struct uref *);
int uref_uri_copy_query(struct uref *, struct uref *);
int uref_uri_match_query(struct uref *, char const *);
int uref_uri_cmp_query(struct uref *, struct uref *);
int uref_uri_get_fragment(struct uref *, char const **);
int uref_uri_set_fragment(struct uref *, char const *);
int uref_uri_delete_fragment(struct uref *);
int uref_uri_copy_fragment(struct uref *, struct uref *);
int uref_uri_match_fragment(struct uref *, char const *);
int uref_uri_cmp_fragment(struct uref *, struct uref *);
void uref_uri_delete(struct uref *);
int uref_uri_import(struct uref *, struct uref *);
]]
libupipe = ffi.load("libupipe.so.0", true)
libupipe_static = ffi.load("libupipe.static.so", true)
