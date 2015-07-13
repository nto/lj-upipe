local ffi = require "ffi"
ffi.cdef [[
struct upipe_mgr *upipe_fsrc_mgr_alloc(void);
void upipe_xfer_mgr_vacuum(struct upipe_mgr *);
struct upipe_mgr *upipe_xfer_mgr_alloc(uint8_t, uint16_t);
struct upipe_mgr *upipe_play_mgr_alloc(void);
struct upipe_mgr *upipe_trickp_mgr_alloc(void);
struct upipe_mgr *upipe_even_mgr_alloc(void);
struct upipe_mgr *upipe_dup_mgr_alloc(void);
struct upipe_mgr *upipe_idem_mgr_alloc(void);
struct upipe_mgr *upipe_null_mgr_alloc(void);
struct upipe_queue_request {
	struct urefcount urefcount;
	struct uchain uchain_sink;
	struct urequest *upstream;
	struct urequest urequest;
};
struct upipe_queue_request *upipe_queue_request_alloc(struct urequest *);
enum upipe_queue_downstream_type {
	UPIPE_QUEUE_DOWNSTREAM_REGISTER,
	UPIPE_QUEUE_DOWNSTREAM_UNREGISTER,
	UPIPE_QUEUE_DOWNSTREAM_SOURCE_END,
	UPIPE_QUEUE_DOWNSTREAM_REF_END,
};
struct upipe_queue_downstream {
	enum upipe_queue_downstream_type type;
	struct upipe_queue_request *request;
};
struct upipe_queue_downstream *upipe_queue_downstream_alloc(enum upipe_queue_downstream_type, struct upipe_queue_request *);
void upipe_queue_downstream_free(struct upipe_queue_downstream *);
enum upipe_queue_upstream_type {
	UPIPE_QUEUE_UPSTREAM_PROVIDE,
};
struct upipe_queue_upstream {
	enum upipe_queue_upstream_type type;
	struct upipe_queue_request *request;
	struct uref *uref;
	struct uref_mgr *uref_mgr;
	struct ubuf_mgr *ubuf_mgr;
	struct uclock *uclock;
	uint64_t uint64;
};
struct upipe_queue_upstream *upipe_queue_upstream_alloc(enum upipe_queue_upstream_type, struct upipe_queue_request *);
void upipe_queue_upstream_free(struct upipe_queue_upstream *);
struct upipe_mgr *upipe_qsrc_mgr_alloc(void);
struct upipe_mgr *upipe_qsink_mgr_alloc(void);
struct upipe_mgr *upipe_udpsrc_mgr_alloc(void);
int upipe_udp_open_socket(struct upipe *, char const *, int, uint16_t, uint16_t, unsigned int *, bool *, bool *, uint8_t *);
struct upipe_mgr *upipe_http_src_mgr_alloc(void);
struct upipe_mgr *upipe_genaux_mgr_alloc(void);
struct upipe_mgr *upipe_multicat_sink_mgr_alloc(void);
struct upipe_mgr *upipe_multicat_probe_mgr_alloc(void);
struct upipe_mgr *upipe_probe_uref_mgr_alloc(void);
struct upipe_mgr *upipe_noclock_mgr_alloc(void);
struct upipe_mgr *upipe_nodemux_mgr_alloc(void);
struct upipe_mgr *upipe_delay_mgr_alloc(void);
struct upipe_mgr *upipe_skip_mgr_alloc(void);
struct upipe_mgr *upipe_agg_mgr_alloc(void);
struct upipe_mgr *upipe_htons_mgr_alloc(void);
struct upipe_mgr *upipe_chunk_stream_mgr_alloc(void);
struct upipe_mgr *upipe_setflowdef_mgr_alloc(void);
struct upipe_mgr *upipe_setattr_mgr_alloc(void);
struct upipe_mgr *upipe_setrap_mgr_alloc(void);
struct upipe_mgr *upipe_match_attr_mgr_alloc(void);
struct upipe_mgr *upipe_blit_mgr_alloc(void);
struct upipe_mgr *upipe_audio_split_mgr_alloc(void);
struct upipe_mgr *upipe_videocont_mgr_alloc(void);
struct upipe_mgr *upipe_audiocont_mgr_alloc(void);
struct upipe_mgr *upipe_blksrc_mgr_alloc(void);
struct upipe_mgr *upipe_sinesrc_mgr_alloc(void);
struct upipe_mgr *upipe_wlin_mgr_alloc(struct upipe_mgr *);
struct upipe_mgr *upipe_wsink_mgr_alloc(struct upipe_mgr *);
struct upipe_mgr *upipe_wsrc_mgr_alloc(struct upipe_mgr *);
struct upipe_mgr *upipe_stream_switcher_mgr_alloc(void);
uint8_t const *upipe_mpeg_scan(uint8_t const *, uint8_t const *, uint8_t *);
struct upipe_mgr *upipe_rtp_h264_mgr_alloc(void);
struct upipe_mgr *upipe_rtp_mpeg4_mgr_alloc(void);
struct upipe_mgr *upipe_dump_mgr_alloc(void);
struct upipe_mgr *upipe_fsink_mgr_alloc(void);
struct upipe_mgr *upipe_udpsink_mgr_alloc(void);
struct upipe_mgr *upipe_rtpd_mgr_alloc(void);
struct upipe_mgr *upipe_rtp_prepend_mgr_alloc(void);
struct upipe_mgr *upipe_rtpsrc_mgr_alloc(void);
int upipe_audiocont_get_current_input(struct upipe *, char const **);
int upipe_audiocont_get_input(struct upipe *, char const **);
int upipe_audiocont_set_input(struct upipe *, char const *);
int upipe_audiocont_get_latency(struct upipe *, uint64_t *);
int upipe_audiocont_set_latency(struct upipe *, uint64_t);
int upipe_audiocont_sub_set_input(struct upipe *);
enum ubase_err {
	UBASE_ERR_NONE,
	UBASE_ERR_UNKNOWN,
	UBASE_ERR_ALLOC,
	UBASE_ERR_UPUMP,
	UBASE_ERR_UNHANDLED,
	UBASE_ERR_INVALID,
	UBASE_ERR_EXTERNAL,
	UBASE_ERR_BUSY,
	UBASE_ERR_LOCAL = 32768,
};
enum ubase_err upipe_blit_sub_get_hposition(struct upipe *, int *);
enum ubase_err upipe_blit_sub_set_hposition(struct upipe *, int);
enum ubase_err upipe_blit_sub_get_vposition(struct upipe *, int *);
enum ubase_err upipe_blit_sub_set_vposition(struct upipe *, int);
enum ubase_err upipe_blit_sub_set_position(struct upipe *, int, int);
enum ubase_err upipe_blit_sub_get_position(struct upipe *, int *, int *);
int upipe_chunk_stream_get_mtu(struct upipe *, unsigned int *, unsigned int *);
int upipe_chunk_stream_set_mtu(struct upipe *, unsigned int, unsigned int);
int upipe_delay_get_delay(struct upipe *, uint64_t *);
int upipe_delay_set_delay(struct upipe *, uint64_t);
int upipe_dump_set_max_len(struct upipe *, size_t);
int upipe_fsink_get_path(struct upipe *, char const **);
enum upipe_fsink_mode {
	UPIPE_FSINK_NONE,
	UPIPE_FSINK_APPEND,
	UPIPE_FSINK_OVERWRITE,
	UPIPE_FSINK_CREATE,
};
int upipe_fsink_set_path(struct upipe *, char const *, enum upipe_fsink_mode);
int upipe_fsink_get_fd(struct upipe *, int *);
int upipe_fsrc_get_size(struct upipe *, uint64_t *);
int upipe_fsrc_get_position(struct upipe *, uint64_t *);
int upipe_fsrc_set_position(struct upipe *, uint64_t);
int upipe_fsrc_set_range(struct upipe *, uint64_t, uint64_t);
int upipe_fsrc_get_range(struct upipe *, uint64_t *, uint64_t *);
int upipe_genaux_set_getattr(struct upipe *, int (*)(struct uref *, uint64_t *));
int upipe_genaux_get_getattr(struct upipe *, int (**)(struct uref *, uint64_t *));
void upipe_genaux_hton64(uint8_t *, uint64_t);
uint64_t upipe_genaux_ntoh64(uint8_t const *);
int upipe_http_src_get_position(struct upipe *, uint64_t *);
int upipe_http_src_set_position(struct upipe *, uint64_t);
int upipe_http_src_set_range(struct upipe *, uint64_t, uint64_t);
int upipe_match_attr_set_uint8_t(struct upipe *, int (*)(struct uref *, uint8_t, uint8_t));
int upipe_match_attr_set_uint64_t(struct upipe *, int (*)(struct uref *, uint64_t, uint64_t));
int upipe_match_attr_set_boundaries(struct upipe *, uint64_t, uint64_t);
int upipe_multicat_probe_get_rotate(struct upipe *, uint64_t *);
int upipe_multicat_probe_set_rotate(struct upipe *, uint64_t);
int upipe_multicat_sink_get_path(struct upipe *, char const **, char const **);
int upipe_multicat_sink_set_path(struct upipe *, char const *, char const *);
int upipe_multicat_sink_get_rotate(struct upipe *, uint64_t *);
int upipe_multicat_sink_set_rotate(struct upipe *, uint64_t);
int upipe_multicat_sink_set_mode(struct upipe *, enum upipe_fsink_mode);
int upipe_multicat_sink_get_fsink_mgr(struct upipe *, struct upipe_mgr *);
int upipe_multicat_sink_set_fsink_mgr(struct upipe *, struct upipe_mgr *);
int upipe_null_dump_dict(struct upipe *, bool);
int upipe_qsrc_get_max_length(struct upipe *, unsigned int *);
int upipe_qsrc_get_length(struct upipe *, unsigned int *);
int upipe_rtcp_get_clockrate(struct upipe *, uint32_t *);
int upipe_rtcp_set_clockrate(struct upipe *, uint32_t);
int upipe_rtcp_get_rate(struct upipe *, uint64_t *);
int upipe_rtcp_set_rate(struct upipe *, uint64_t);
int upipe_rtp_prepend_get_type(struct upipe *, uint8_t *);
int upipe_rtp_prepend_set_type(struct upipe *, uint8_t);
int upipe_rtp_prepend_set_clockrate(struct upipe *, uint32_t);
int upipe_rtp_prepend_get_clockrate(struct upipe *, uint32_t *);
enum upipe_rtp_prepend_ts_sync {
	UPIPE_RTP_PREPEND_TS_SYNC_CR,
	UPIPE_RTP_PREPEND_TS_SYNC_PTS,
};
int upipe_rtp_prepend_set_ts_sync(struct upipe *, enum upipe_rtp_prepend_ts_sync);
int upipe_rtp_prepend_get_ts_sync(struct upipe *, enum upipe_rtp_prepend_ts_sync *);
int upipe_rtpsrc_mgr_get_udpsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_rtpsrc_mgr_set_udpsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_rtpsrc_mgr_get_rtpd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_rtpsrc_mgr_set_rtpd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_setattr_get_dict(struct upipe *, struct uref **);
int upipe_setattr_set_dict(struct upipe *, struct uref *);
int upipe_setflowdef_get_dict(struct upipe *, struct uref **);
int upipe_setflowdef_set_dict(struct upipe *, struct uref *);
int upipe_setrap_get_rap(struct upipe *, uint64_t *);
int upipe_setrap_set_rap(struct upipe *, uint64_t);
int upipe_skip_get_offset(struct upipe *, size_t *);
int upipe_skip_set_offset(struct upipe *, size_t);
int upipe_xfer_mgr_attach(struct upipe_mgr *, struct upump_mgr *);
int upipe_trickp_get_rate(struct upipe *, struct urational *);
int upipe_trickp_set_rate(struct upipe *, struct urational);
int upipe_udpsink_get_uri(struct upipe *, char const **);
enum upipe_udpsink_mode {
	UPIPE_UDPSINK_NONE,
};
int upipe_udpsink_set_uri(struct upipe *, char const *, enum upipe_udpsink_mode);
int upipe_videocont_get_current_input(struct upipe *, char const **);
int upipe_videocont_get_input(struct upipe *, char const **);
int upipe_videocont_set_input(struct upipe *, char const *);
int upipe_videocont_get_tolerance(struct upipe *, uint64_t *);
int upipe_videocont_set_tolerance(struct upipe *, uint64_t);
int upipe_videocont_get_latency(struct upipe *, uint64_t *);
int upipe_videocont_set_latency(struct upipe *, uint64_t);
int upipe_videocont_sub_set_input(struct upipe *);
int upipe_wlin_mgr_get_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wlin_mgr_set_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wlin_mgr_get_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wlin_mgr_set_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsink_mgr_get_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsink_mgr_set_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsink_mgr_get_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsink_mgr_set_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsrc_mgr_get_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsrc_mgr_set_qsrc_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsrc_mgr_get_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_wsrc_mgr_set_qsink_mgr(struct upipe_mgr *, struct upipe_mgr *);
]]
libupipe_modules = ffi.load("libupipe_modules.so", true)
libupipe_modules_static = ffi.load("libupipe-modules.static.so", true)
