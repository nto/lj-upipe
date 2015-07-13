local ffi = require "ffi"
ffi.cdef [[
struct upipe_mgr *upipe_ts_check_mgr_alloc(void);
struct upipe_mgr *upipe_ts_decaps_mgr_alloc(void);
struct upipe_mgr *upipe_ts_eitd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_nitd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_pesd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_patd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_pmtd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_psi_join_mgr_alloc(void);
struct upipe_mgr *upipe_ts_psim_mgr_alloc(void);
struct upipe_mgr *upipe_ts_psi_split_mgr_alloc(void);
struct upipe_mgr *upipe_ts_sdtd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_tdtd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_split_mgr_alloc(void);
struct upipe_mgr *upipe_ts_sync_mgr_alloc(void);
struct upipe_mgr *upipe_ts_demux_mgr_alloc(void);
struct upipe_mgr *upipe_ts_tstd_mgr_alloc(void);
struct upipe_mgr *upipe_ts_encaps_mgr_alloc(void);
struct upipe_mgr *upipe_ts_pese_mgr_alloc(void);
struct upipe_mgr *upipe_ts_psig_mgr_alloc(void);
struct upipe_mgr *upipe_ts_sig_mgr_alloc(void);
struct upipe_mgr *upipe_ts_mux_mgr_alloc(void);
enum upipe_ts_conformance {
	UPIPE_TS_CONFORMANCE_AUTO,
	UPIPE_TS_CONFORMANCE_ISO,
	UPIPE_TS_CONFORMANCE_DVB_NO_TABLES,
	UPIPE_TS_CONFORMANCE_DVB,
	UPIPE_TS_CONFORMANCE_ATSC,
	UPIPE_TS_CONFORMANCE_ISDB,
};
char const *upipe_ts_conformance_print(enum upipe_ts_conformance);
int upipe_ts_conformance_to_flow_def(struct uref *, enum upipe_ts_conformance);
enum upipe_ts_conformance upipe_ts_conformance_from_string(char const *);
enum upipe_ts_conformance upipe_ts_conformance_from_flow_def(struct uref *);
int upipe_ts_demux_get_conformance(struct upipe *, enum upipe_ts_conformance *);
int upipe_ts_demux_set_conformance(struct upipe *, enum upipe_ts_conformance);
int upipe_ts_demux_mgr_get_null_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_null_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_split_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_split_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_sync_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_sync_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_check_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_check_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_decaps_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_decaps_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_psim_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_psim_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_psi_split_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_psi_split_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_patd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_patd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_nitd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_nitd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_sdtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_sdtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_tdtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_tdtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_pmtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_pmtd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_eitd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_eitd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_ts_pesd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_ts_pesd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_mpgaf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_mpgaf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_a52f_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_a52f_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_mpgvf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_mpgvf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_h264f_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_h264f_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_telxf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_telxf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_dvbsubf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_dvbsubf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_get_opusf_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_demux_mgr_set_opusf_mgr(struct upipe_mgr *, struct upipe_mgr *);
enum upipe_ts_mux_mode {
	UPIPE_TS_MUX_MODE_CBR,
	UPIPE_TS_MUX_MODE_CAPPED,
};
char const *upipe_ts_mux_mode_print(enum upipe_ts_mux_mode);
int upipe_ts_mux_get_conformance(struct upipe *, enum upipe_ts_conformance *);
int upipe_ts_mux_set_conformance(struct upipe *, enum upipe_ts_conformance);
int upipe_ts_mux_get_cc(struct upipe *, unsigned int *);
int upipe_ts_mux_set_cc(struct upipe *, unsigned int);
int upipe_ts_mux_set_cr_prog(struct upipe *, uint64_t);
int upipe_ts_mux_get_pat_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_pat_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_pmt_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_pmt_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_nit_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_nit_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_sdt_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_sdt_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_eit_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_eit_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_tdt_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_tdt_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_pcr_interval(struct upipe *, uint64_t *);
int upipe_ts_mux_set_pcr_interval(struct upipe *, uint64_t);
int upipe_ts_mux_get_max_delay(struct upipe *, uint64_t *);
int upipe_ts_mux_set_max_delay(struct upipe *, uint64_t);
int upipe_ts_mux_get_mux_delay(struct upipe *, uint64_t *);
int upipe_ts_mux_set_mux_delay(struct upipe *, uint64_t);
int upipe_ts_mux_get_octetrate(struct upipe *, uint64_t *);
int upipe_ts_mux_set_octetrate(struct upipe *, uint64_t);
int upipe_ts_mux_get_padding_octetrate(struct upipe *, uint64_t *);
int upipe_ts_mux_set_padding_octetrate(struct upipe *, uint64_t);
int upipe_ts_mux_get_mode(struct upipe *, enum upipe_ts_mux_mode *);
int upipe_ts_mux_set_mode(struct upipe *, enum upipe_ts_mux_mode);
int upipe_ts_mux_get_version(struct upipe *, unsigned int *);
int upipe_ts_mux_set_version(struct upipe *, unsigned int);
int upipe_ts_mux_freeze_psi(struct upipe *);
int upipe_ts_mux_mgr_get_ts_encaps_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_set_ts_encaps_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_get_ts_tstd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_set_ts_tstd_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_get_ts_psi_join_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_set_ts_psi_join_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_get_ts_psig_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_set_ts_psig_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_get_ts_sig_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_mux_mgr_set_ts_sig_mgr(struct upipe_mgr *, struct upipe_mgr *);
int upipe_ts_encaps_set_tb_size(struct upipe *, unsigned int);
int upipe_ts_encaps_splice(struct upipe *, uint64_t, struct ubuf **, uint64_t *);
int upipe_ts_encaps_eos(struct upipe *);
bool upipe_ts_patd_get_nit(struct upipe *, struct uref **);
bool upipe_ts_psig_program_get_pcr_pid(struct upipe *, unsigned int *);
bool upipe_ts_psig_program_set_pcr_pid(struct upipe *, unsigned int);
int upipe_ts_psig_prepare(struct upipe *, uint64_t);
int upipe_ts_sig_prepare(struct upipe *, uint64_t, uint64_t);
int upipe_ts_sig_get_nit_sub(struct upipe *, struct upipe **);
int upipe_ts_sig_get_sdt_sub(struct upipe *, struct upipe **);
int upipe_ts_sig_get_eit_sub(struct upipe *, struct upipe **);
int upipe_ts_sig_get_tdt_sub(struct upipe *, struct upipe **);
int upipe_ts_sync_get_sync(struct upipe *, int *);
int upipe_ts_sync_set_sync(struct upipe *, int);
]]
libupipe_ts = ffi.load("libupipe_ts.so", true)
libupipe_ts_static = ffi.load("libupipe-ts.static.so", true)
