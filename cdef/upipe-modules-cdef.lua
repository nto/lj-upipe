local ffi = require("ffi")
ffi.cdef [[
enum uprobe_http_src_event {
	UPROBE_HTTP_SRC_SENTINEL = 32768,
	UPROBE_HTTP_SRC_REDIRECT,
};
enum uprobe_multicat_probe_event {
	UPROBE_MULTICAT_PROBE_SENTINEL = 32768,
	UPROBE_MULTICAT_PROBE_ROTATE,
};
enum uprobe_probe_uref_event {
	UPROBE_PROBE_SENTINEL = 32768,
	UPROBE_PROBE_UREF,
};
enum uprobe_stream_switcher_sub_event {
	UPROBE_STREAM_SWITCHER_SUB_SENTINEL = 32768,
	UPROBE_STREAM_SWITCHER_SUB_SYNC,
	UPROBE_STREAM_SWITCHER_SUB_ENTERING,
	UPROBE_STREAM_SWITCHER_SUB_LEAVING,
	UPROBE_STREAM_SWITCHER_SUB_DESTROY,
};
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
struct upipe_mgr *upipe_rtp_opus_mgr_alloc(void);
struct upipe_mgr *upipe_rtcp_mgr_alloc(void);
struct upipe_mgr *upipe_dump_mgr_alloc(void);
struct uprobe_http_redir {
	struct uprobe uprobe;
};
struct uprobe *uprobe_http_redir_init(struct uprobe_http_redir *, struct uprobe *);
void uprobe_http_redir_clean(struct uprobe_http_redir *);
struct uprobe *uprobe_http_redir_alloc(struct uprobe *);
struct upipe_mgr *upipe_m3u_reader_mgr_alloc(void);
struct upipe_mgr *upipe_m3u_playlist_mgr_alloc(void);
void upipe_auto_src_mgr_free(struct urefcount *);
struct upipe_mgr *upipe_auto_src_mgr_alloc(void);
struct upipe_mgr *upipe_buffer_mgr_alloc(void);
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
int upipe_auto_src_mgr_set_mgr(struct upipe_mgr *, char const *, struct upipe_mgr *);
int upipe_auto_src_mgr_get_mgr(struct upipe_mgr *, char const *, struct upipe_mgr **);
int upipe_blit_sub_get_rect(struct upipe *, uint64_t *, uint64_t *, uint64_t *, uint64_t *);
int upipe_blit_sub_set_rect(struct upipe *, uint64_t, uint64_t, uint64_t, uint64_t);
char const *upipe_buffer_command_str(int);
int upipe_buffer_get_max_size(struct upipe *, uint64_t *);
int upipe_buffer_set_max_size(struct upipe *, uint64_t);
int upipe_buffer_set_low_limit(struct upipe *, uint64_t);
int upipe_buffer_get_low_limit(struct upipe *, uint64_t *);
int upipe_buffer_set_high_limit(struct upipe *, uint64_t);
int upipe_buffer_get_high_limit(struct upipe *, uint64_t *);
enum upipe_buffer_state {
	UPIPE_BUFFER_LOW,
	UPIPE_BUFFER_MIDDLE,
	UPIPE_BUFFER_HIGH,
};
char const *upipe_buffer_state_str(enum upipe_buffer_state);
char const *upipe_buffer_event_str(int);
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
int upipe_genaux_set_getattr(struct upipe *, int (*)(struct uref *, uint64_t *));
int upipe_genaux_get_getattr(struct upipe *, int (**)(struct uref *, uint64_t *));
void upipe_genaux_hton64(uint8_t *, uint64_t);
uint64_t upipe_genaux_ntoh64(uint8_t const *);
char const *uprobe_http_src_event_str(int);
int upipe_http_src_throw_redirect(struct upipe *, char const *);
char const *upipe_http_src_command_str(int);
int upipe_http_src_set_proxy(struct upipe *, char const *);
int upipe_http_src_mgr_set_proxy(struct upipe_mgr *, char const *);
int upipe_http_src_mgr_get_proxy(struct upipe_mgr *, char const **);
int upipe_http_src_mgr_set_cookie(struct upipe_mgr *, char const *);
int upipe_http_src_mgr_iterate_cookie(struct upipe_mgr *, char const *, char const *, struct uchain **);
char const *upipe_m3u_playlist_command_str(int);
int upipe_m3u_playlist_set_source_mgr(struct upipe *, struct upipe_mgr *);
int upipe_m3u_playlist_get_index(struct upipe *, uint64_t *);
int upipe_m3u_playlist_set_index(struct upipe *, uint64_t);
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
char const *uprobe_stream_switcher_sub_event_str(int);
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
libupipe_modules = ffi.load("libupipe_modules.so.0", true)
libupipe_modules_static = ffi.load("libupipe-modules.static.so", true)
