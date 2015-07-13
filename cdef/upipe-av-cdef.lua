local ffi = require "ffi"
ffi.cdef [[
bool upipe_av_init(bool, struct uprobe *);
void upipe_av_clean(void);
enum AVCodecID {
	AV_CODEC_ID_NONE,
	AV_CODEC_ID_MPEG1VIDEO,
	AV_CODEC_ID_MPEG2VIDEO,
	AV_CODEC_ID_MPEG2VIDEO_XVMC,
	AV_CODEC_ID_H261,
	AV_CODEC_ID_H263,
	AV_CODEC_ID_RV10,
	AV_CODEC_ID_RV20,
	AV_CODEC_ID_MJPEG,
	AV_CODEC_ID_MJPEGB,
	AV_CODEC_ID_LJPEG,
	AV_CODEC_ID_SP5X,
	AV_CODEC_ID_JPEGLS,
	AV_CODEC_ID_MPEG4,
	AV_CODEC_ID_RAWVIDEO,
	AV_CODEC_ID_MSMPEG4V1,
	AV_CODEC_ID_MSMPEG4V2,
	AV_CODEC_ID_MSMPEG4V3,
	AV_CODEC_ID_WMV1,
	AV_CODEC_ID_WMV2,
	AV_CODEC_ID_H263P,
	AV_CODEC_ID_H263I,
	AV_CODEC_ID_FLV1,
	AV_CODEC_ID_SVQ1,
	AV_CODEC_ID_SVQ3,
	AV_CODEC_ID_DVVIDEO,
	AV_CODEC_ID_HUFFYUV,
	AV_CODEC_ID_CYUV,
	AV_CODEC_ID_H264,
	AV_CODEC_ID_INDEO3,
	AV_CODEC_ID_VP3,
	AV_CODEC_ID_THEORA,
	AV_CODEC_ID_ASV1,
	AV_CODEC_ID_ASV2,
	AV_CODEC_ID_FFV1,
	AV_CODEC_ID_4XM,
	AV_CODEC_ID_VCR1,
	AV_CODEC_ID_CLJR,
	AV_CODEC_ID_MDEC,
	AV_CODEC_ID_ROQ,
	AV_CODEC_ID_INTERPLAY_VIDEO,
	AV_CODEC_ID_XAN_WC3,
	AV_CODEC_ID_XAN_WC4,
	AV_CODEC_ID_RPZA,
	AV_CODEC_ID_CINEPAK,
	AV_CODEC_ID_WS_VQA,
	AV_CODEC_ID_MSRLE,
	AV_CODEC_ID_MSVIDEO1,
	AV_CODEC_ID_IDCIN,
	AV_CODEC_ID_8BPS,
	AV_CODEC_ID_SMC,
	AV_CODEC_ID_FLIC,
	AV_CODEC_ID_TRUEMOTION1,
	AV_CODEC_ID_VMDVIDEO,
	AV_CODEC_ID_MSZH,
	AV_CODEC_ID_ZLIB,
	AV_CODEC_ID_QTRLE,
	AV_CODEC_ID_TSCC,
	AV_CODEC_ID_ULTI,
	AV_CODEC_ID_QDRAW,
	AV_CODEC_ID_VIXL,
	AV_CODEC_ID_QPEG,
	AV_CODEC_ID_PNG,
	AV_CODEC_ID_PPM,
	AV_CODEC_ID_PBM,
	AV_CODEC_ID_PGM,
	AV_CODEC_ID_PGMYUV,
	AV_CODEC_ID_PAM,
	AV_CODEC_ID_FFVHUFF,
	AV_CODEC_ID_RV30,
	AV_CODEC_ID_RV40,
	AV_CODEC_ID_VC1,
	AV_CODEC_ID_WMV3,
	AV_CODEC_ID_LOCO,
	AV_CODEC_ID_WNV1,
	AV_CODEC_ID_AASC,
	AV_CODEC_ID_INDEO2,
	AV_CODEC_ID_FRAPS,
	AV_CODEC_ID_TRUEMOTION2,
	AV_CODEC_ID_BMP,
	AV_CODEC_ID_CSCD,
	AV_CODEC_ID_MMVIDEO,
	AV_CODEC_ID_ZMBV,
	AV_CODEC_ID_AVS,
	AV_CODEC_ID_SMACKVIDEO,
	AV_CODEC_ID_NUV,
	AV_CODEC_ID_KMVC,
	AV_CODEC_ID_FLASHSV,
	AV_CODEC_ID_CAVS,
	AV_CODEC_ID_JPEG2000,
	AV_CODEC_ID_VMNC,
	AV_CODEC_ID_VP5,
	AV_CODEC_ID_VP6,
	AV_CODEC_ID_VP6F,
	AV_CODEC_ID_TARGA,
	AV_CODEC_ID_DSICINVIDEO,
	AV_CODEC_ID_TIERTEXSEQVIDEO,
	AV_CODEC_ID_TIFF,
	AV_CODEC_ID_GIF,
	AV_CODEC_ID_DXA,
	AV_CODEC_ID_DNXHD,
	AV_CODEC_ID_THP,
	AV_CODEC_ID_SGI,
	AV_CODEC_ID_C93,
	AV_CODEC_ID_BETHSOFTVID,
	AV_CODEC_ID_PTX,
	AV_CODEC_ID_TXD,
	AV_CODEC_ID_VP6A,
	AV_CODEC_ID_AMV,
	AV_CODEC_ID_VB,
	AV_CODEC_ID_PCX,
	AV_CODEC_ID_SUNRAST,
	AV_CODEC_ID_INDEO4,
	AV_CODEC_ID_INDEO5,
	AV_CODEC_ID_MIMIC,
	AV_CODEC_ID_RL2,
	AV_CODEC_ID_ESCAPE124,
	AV_CODEC_ID_DIRAC,
	AV_CODEC_ID_BFI,
	AV_CODEC_ID_CMV,
	AV_CODEC_ID_MOTIONPIXELS,
	AV_CODEC_ID_TGV,
	AV_CODEC_ID_TGQ,
	AV_CODEC_ID_TQI,
	AV_CODEC_ID_AURA,
	AV_CODEC_ID_AURA2,
	AV_CODEC_ID_V210X,
	AV_CODEC_ID_TMV,
	AV_CODEC_ID_V210,
	AV_CODEC_ID_DPX,
	AV_CODEC_ID_MAD,
	AV_CODEC_ID_FRWU,
	AV_CODEC_ID_FLASHSV2,
	AV_CODEC_ID_CDGRAPHICS,
	AV_CODEC_ID_R210,
	AV_CODEC_ID_ANM,
	AV_CODEC_ID_BINKVIDEO,
	AV_CODEC_ID_IFF_ILBM,
	AV_CODEC_ID_IFF_BYTERUN1,
	AV_CODEC_ID_KGV1,
	AV_CODEC_ID_YOP,
	AV_CODEC_ID_VP8,
	AV_CODEC_ID_PICTOR,
	AV_CODEC_ID_ANSI,
	AV_CODEC_ID_A64_MULTI,
	AV_CODEC_ID_A64_MULTI5,
	AV_CODEC_ID_R10K,
	AV_CODEC_ID_MXPEG,
	AV_CODEC_ID_LAGARITH,
	AV_CODEC_ID_PRORES,
	AV_CODEC_ID_JV,
	AV_CODEC_ID_DFA,
	AV_CODEC_ID_WMV3IMAGE,
	AV_CODEC_ID_VC1IMAGE,
	AV_CODEC_ID_UTVIDEO,
	AV_CODEC_ID_BMV_VIDEO,
	AV_CODEC_ID_VBLE,
	AV_CODEC_ID_DXTORY,
	AV_CODEC_ID_V410,
	AV_CODEC_ID_XWD,
	AV_CODEC_ID_CDXL,
	AV_CODEC_ID_XBM,
	AV_CODEC_ID_ZEROCODEC,
	AV_CODEC_ID_MSS1,
	AV_CODEC_ID_MSA1,
	AV_CODEC_ID_TSCC2,
	AV_CODEC_ID_MTS2,
	AV_CODEC_ID_CLLC,
	AV_CODEC_ID_MSS2,
	AV_CODEC_ID_VP9,
	AV_CODEC_ID_AIC,
	AV_CODEC_ID_ESCAPE130_DEPRECATED,
	AV_CODEC_ID_G2M_DEPRECATED,
	AV_CODEC_ID_WEBP_DEPRECATED,
	AV_CODEC_ID_HNM4_VIDEO,
	AV_CODEC_ID_HEVC_DEPRECATED,
	AV_CODEC_ID_FIC,
	AV_CODEC_ID_ALIAS_PIX,
	AV_CODEC_ID_BRENDER_PIX_DEPRECATED,
	AV_CODEC_ID_PAF_VIDEO_DEPRECATED,
	AV_CODEC_ID_EXR_DEPRECATED,
	AV_CODEC_ID_VP7_DEPRECATED,
	AV_CODEC_ID_SANM_DEPRECATED,
	AV_CODEC_ID_SGIRLE_DEPRECATED,
	AV_CODEC_ID_MVC1_DEPRECATED,
	AV_CODEC_ID_MVC2_DEPRECATED,
	AV_CODEC_ID_HQX,
	AV_CODEC_ID_BRENDER_PIX = 1112557912,
	AV_CODEC_ID_Y41P = 1496592720,
	AV_CODEC_ID_ESCAPE130 = 1160852272,
	AV_CODEC_ID_EXR = 809850962,
	AV_CODEC_ID_AVRP = 1096176208,
	AV_CODEC_ID_012V = 808530518,
	AV_CODEC_ID_G2M = 4665933,
	AV_CODEC_ID_AVUI = 1096176969,
	AV_CODEC_ID_AYUV = 1096373590,
	AV_CODEC_ID_TARGA_Y216 = 1412575542,
	AV_CODEC_ID_V308 = 1446195256,
	AV_CODEC_ID_V408 = 1446260792,
	AV_CODEC_ID_YUV4 = 1498764852,
	AV_CODEC_ID_SANM = 1396788813,
	AV_CODEC_ID_PAF_VIDEO = 1346455126,
	AV_CODEC_ID_AVRN = 1096176238,
	AV_CODEC_ID_CPIA = 1129335105,
	AV_CODEC_ID_XFACE = 1480999235,
	AV_CODEC_ID_SGIRLE = 1397180754,
	AV_CODEC_ID_MVC1 = 1297498929,
	AV_CODEC_ID_MVC2,
	AV_CODEC_ID_SNOW = 1397641047,
	AV_CODEC_ID_WEBP = 1464156752,
	AV_CODEC_ID_SMVJPEG = 1397577290,
	AV_CODEC_ID_HEVC = 1211250229,
	AV_CODEC_ID_VP7 = 1448097584,
	AV_CODEC_ID_APNG = 1095781959,
	AV_CODEC_ID_FIRST_AUDIO = 65536,
	AV_CODEC_ID_PCM_S16LE = 65536,
	AV_CODEC_ID_PCM_S16BE,
	AV_CODEC_ID_PCM_U16LE,
	AV_CODEC_ID_PCM_U16BE,
	AV_CODEC_ID_PCM_S8,
	AV_CODEC_ID_PCM_U8,
	AV_CODEC_ID_PCM_MULAW,
	AV_CODEC_ID_PCM_ALAW,
	AV_CODEC_ID_PCM_S32LE,
	AV_CODEC_ID_PCM_S32BE,
	AV_CODEC_ID_PCM_U32LE,
	AV_CODEC_ID_PCM_U32BE,
	AV_CODEC_ID_PCM_S24LE,
	AV_CODEC_ID_PCM_S24BE,
	AV_CODEC_ID_PCM_U24LE,
	AV_CODEC_ID_PCM_U24BE,
	AV_CODEC_ID_PCM_S24DAUD,
	AV_CODEC_ID_PCM_ZORK,
	AV_CODEC_ID_PCM_S16LE_PLANAR,
	AV_CODEC_ID_PCM_DVD,
	AV_CODEC_ID_PCM_F32BE,
	AV_CODEC_ID_PCM_F32LE,
	AV_CODEC_ID_PCM_F64BE,
	AV_CODEC_ID_PCM_F64LE,
	AV_CODEC_ID_PCM_BLURAY,
	AV_CODEC_ID_PCM_LXF,
	AV_CODEC_ID_S302M,
	AV_CODEC_ID_PCM_S8_PLANAR,
	AV_CODEC_ID_PCM_S24LE_PLANAR_DEPRECATED,
	AV_CODEC_ID_PCM_S32LE_PLANAR_DEPRECATED,
	AV_CODEC_ID_PCM_S24LE_PLANAR = 407917392,
	AV_CODEC_ID_PCM_S32LE_PLANAR = 542135120,
	AV_CODEC_ID_PCM_S16BE_PLANAR = 1347637264,
	AV_CODEC_ID_ADPCM_IMA_QT = 69632,
	AV_CODEC_ID_ADPCM_IMA_WAV,
	AV_CODEC_ID_ADPCM_IMA_DK3,
	AV_CODEC_ID_ADPCM_IMA_DK4,
	AV_CODEC_ID_ADPCM_IMA_WS,
	AV_CODEC_ID_ADPCM_IMA_SMJPEG,
	AV_CODEC_ID_ADPCM_MS,
	AV_CODEC_ID_ADPCM_4XM,
	AV_CODEC_ID_ADPCM_XA,
	AV_CODEC_ID_ADPCM_ADX,
	AV_CODEC_ID_ADPCM_EA,
	AV_CODEC_ID_ADPCM_G726,
	AV_CODEC_ID_ADPCM_CT,
	AV_CODEC_ID_ADPCM_SWF,
	AV_CODEC_ID_ADPCM_YAMAHA,
	AV_CODEC_ID_ADPCM_SBPRO_4,
	AV_CODEC_ID_ADPCM_SBPRO_3,
	AV_CODEC_ID_ADPCM_SBPRO_2,
	AV_CODEC_ID_ADPCM_THP,
	AV_CODEC_ID_ADPCM_IMA_AMV,
	AV_CODEC_ID_ADPCM_EA_R1,
	AV_CODEC_ID_ADPCM_EA_R3,
	AV_CODEC_ID_ADPCM_EA_R2,
	AV_CODEC_ID_ADPCM_IMA_EA_SEAD,
	AV_CODEC_ID_ADPCM_IMA_EA_EACS,
	AV_CODEC_ID_ADPCM_EA_XAS,
	AV_CODEC_ID_ADPCM_EA_MAXIS_XA,
	AV_CODEC_ID_ADPCM_IMA_ISS,
	AV_CODEC_ID_ADPCM_G722,
	AV_CODEC_ID_ADPCM_IMA_APC,
	AV_CODEC_ID_ADPCM_VIMA_DEPRECATED,
	AV_CODEC_ID_ADPCM_VIMA = 1447644481,
	AV_CODEC_ID_VIMA = 1447644481,
	AV_CODEC_ID_ADPCM_AFC = 1095123744,
	AV_CODEC_ID_ADPCM_IMA_OKI = 1330333984,
	AV_CODEC_ID_ADPCM_DTK = 1146374944,
	AV_CODEC_ID_ADPCM_IMA_RAD = 1380008992,
	AV_CODEC_ID_ADPCM_G726LE = 909260615,
	AV_CODEC_ID_AMR_NB = 73728,
	AV_CODEC_ID_AMR_WB,
	AV_CODEC_ID_RA_144 = 77824,
	AV_CODEC_ID_RA_288,
	AV_CODEC_ID_ROQ_DPCM = 81920,
	AV_CODEC_ID_INTERPLAY_DPCM,
	AV_CODEC_ID_XAN_DPCM,
	AV_CODEC_ID_SOL_DPCM,
	AV_CODEC_ID_MP2 = 86016,
	AV_CODEC_ID_MP3,
	AV_CODEC_ID_AAC,
	AV_CODEC_ID_AC3,
	AV_CODEC_ID_DTS,
	AV_CODEC_ID_VORBIS,
	AV_CODEC_ID_DVAUDIO,
	AV_CODEC_ID_WMAV1,
	AV_CODEC_ID_WMAV2,
	AV_CODEC_ID_MACE3,
	AV_CODEC_ID_MACE6,
	AV_CODEC_ID_VMDAUDIO,
	AV_CODEC_ID_FLAC,
	AV_CODEC_ID_MP3ADU,
	AV_CODEC_ID_MP3ON4,
	AV_CODEC_ID_SHORTEN,
	AV_CODEC_ID_ALAC,
	AV_CODEC_ID_WESTWOOD_SND1,
	AV_CODEC_ID_GSM,
	AV_CODEC_ID_QDM2,
	AV_CODEC_ID_COOK,
	AV_CODEC_ID_TRUESPEECH,
	AV_CODEC_ID_TTA,
	AV_CODEC_ID_SMACKAUDIO,
	AV_CODEC_ID_QCELP,
	AV_CODEC_ID_WAVPACK,
	AV_CODEC_ID_DSICINAUDIO,
	AV_CODEC_ID_IMC,
	AV_CODEC_ID_MUSEPACK7,
	AV_CODEC_ID_MLP,
	AV_CODEC_ID_GSM_MS,
	AV_CODEC_ID_ATRAC3,
	AV_CODEC_ID_VOXWARE,
	AV_CODEC_ID_APE,
	AV_CODEC_ID_NELLYMOSER,
	AV_CODEC_ID_MUSEPACK8,
	AV_CODEC_ID_SPEEX,
	AV_CODEC_ID_WMAVOICE,
	AV_CODEC_ID_WMAPRO,
	AV_CODEC_ID_WMALOSSLESS,
	AV_CODEC_ID_ATRAC3P,
	AV_CODEC_ID_EAC3,
	AV_CODEC_ID_SIPR,
	AV_CODEC_ID_MP1,
	AV_CODEC_ID_TWINVQ,
	AV_CODEC_ID_TRUEHD,
	AV_CODEC_ID_MP4ALS,
	AV_CODEC_ID_ATRAC1,
	AV_CODEC_ID_BINKAUDIO_RDFT,
	AV_CODEC_ID_BINKAUDIO_DCT,
	AV_CODEC_ID_AAC_LATM,
	AV_CODEC_ID_QDMC,
	AV_CODEC_ID_CELT,
	AV_CODEC_ID_G723_1,
	AV_CODEC_ID_G729,
	AV_CODEC_ID_8SVX_EXP,
	AV_CODEC_ID_8SVX_FIB,
	AV_CODEC_ID_BMV_AUDIO,
	AV_CODEC_ID_RALF,
	AV_CODEC_ID_IAC,
	AV_CODEC_ID_ILBC,
	AV_CODEC_ID_OPUS_DEPRECATED,
	AV_CODEC_ID_COMFORT_NOISE,
	AV_CODEC_ID_TAK_DEPRECATED,
	AV_CODEC_ID_METASOUND,
	AV_CODEC_ID_PAF_AUDIO_DEPRECATED,
	AV_CODEC_ID_ON2AVC,
	AV_CODEC_ID_DSS_SP,
	AV_CODEC_ID_FFWAVESYNTH = 1179014995,
	AV_CODEC_ID_SONIC = 1397706307,
	AV_CODEC_ID_SONIC_LS = 1397706316,
	AV_CODEC_ID_PAF_AUDIO = 1346455105,
	AV_CODEC_ID_OPUS = 1330664787,
	AV_CODEC_ID_TAK = 1950507339,
	AV_CODEC_ID_EVRC = 1936029283,
	AV_CODEC_ID_SMV = 1936944502,
	AV_CODEC_ID_DSD_LSBF = 1146307660,
	AV_CODEC_ID_DSD_MSBF,
	AV_CODEC_ID_DSD_LSBF_PLANAR = 1146307633,
	AV_CODEC_ID_DSD_MSBF_PLANAR = 1146307640,
	AV_CODEC_ID_FIRST_SUBTITLE = 94208,
	AV_CODEC_ID_DVD_SUBTITLE = 94208,
	AV_CODEC_ID_DVB_SUBTITLE,
	AV_CODEC_ID_TEXT,
	AV_CODEC_ID_XSUB,
	AV_CODEC_ID_SSA,
	AV_CODEC_ID_MOV_TEXT,
	AV_CODEC_ID_HDMV_PGS_SUBTITLE,
	AV_CODEC_ID_DVB_TELETEXT,
	AV_CODEC_ID_SRT,
	AV_CODEC_ID_MICRODVD = 1833195076,
	AV_CODEC_ID_EIA_608 = 1664495672,
	AV_CODEC_ID_JACOSUB = 1246975298,
	AV_CODEC_ID_SAMI = 1396788553,
	AV_CODEC_ID_REALTEXT = 1381259348,
	AV_CODEC_ID_STL = 1399870540,
	AV_CODEC_ID_SUBVIEWER1 = 1398953521,
	AV_CODEC_ID_SUBVIEWER = 1400201814,
	AV_CODEC_ID_SUBRIP = 1397909872,
	AV_CODEC_ID_WEBVTT = 1465275476,
	AV_CODEC_ID_MPL2 = 1297108018,
	AV_CODEC_ID_VPLAYER = 1448111218,
	AV_CODEC_ID_PJS = 1349012051,
	AV_CODEC_ID_ASS = 1095979808,
	AV_CODEC_ID_FIRST_UNKNOWN = 98304,
	AV_CODEC_ID_TTF = 98304,
	AV_CODEC_ID_BINTEXT = 1112823892,
	AV_CODEC_ID_XBIN = 1480739150,
	AV_CODEC_ID_IDF = 4801606,
	AV_CODEC_ID_OTF = 5198918,
	AV_CODEC_ID_SMPTE_KLV = 1263294017,
	AV_CODEC_ID_DVD_NAV = 1145979222,
	AV_CODEC_ID_TIMED_ID3 = 1414087731,
	AV_CODEC_ID_BIN_DATA = 1145132097,
	AV_CODEC_ID_PROBE = 102400,
	AV_CODEC_ID_MPEG2TS = 131072,
	AV_CODEC_ID_MPEG4SYSTEMS,
	AV_CODEC_ID_FFMETADATA = 135168,
	CODEC_ID_NONE = 0,
	CODEC_ID_MPEG1VIDEO,
	CODEC_ID_MPEG2VIDEO,
	CODEC_ID_MPEG2VIDEO_XVMC,
	CODEC_ID_H261,
	CODEC_ID_H263,
	CODEC_ID_RV10,
	CODEC_ID_RV20,
	CODEC_ID_MJPEG,
	CODEC_ID_MJPEGB,
	CODEC_ID_LJPEG,
	CODEC_ID_SP5X,
	CODEC_ID_JPEGLS,
	CODEC_ID_MPEG4,
	CODEC_ID_RAWVIDEO,
	CODEC_ID_MSMPEG4V1,
	CODEC_ID_MSMPEG4V2,
	CODEC_ID_MSMPEG4V3,
	CODEC_ID_WMV1,
	CODEC_ID_WMV2,
	CODEC_ID_H263P,
	CODEC_ID_H263I,
	CODEC_ID_FLV1,
	CODEC_ID_SVQ1,
	CODEC_ID_SVQ3,
	CODEC_ID_DVVIDEO,
	CODEC_ID_HUFFYUV,
	CODEC_ID_CYUV,
	CODEC_ID_H264,
	CODEC_ID_INDEO3,
	CODEC_ID_VP3,
	CODEC_ID_THEORA,
	CODEC_ID_ASV1,
	CODEC_ID_ASV2,
	CODEC_ID_FFV1,
	CODEC_ID_4XM,
	CODEC_ID_VCR1,
	CODEC_ID_CLJR,
	CODEC_ID_MDEC,
	CODEC_ID_ROQ,
	CODEC_ID_INTERPLAY_VIDEO,
	CODEC_ID_XAN_WC3,
	CODEC_ID_XAN_WC4,
	CODEC_ID_RPZA,
	CODEC_ID_CINEPAK,
	CODEC_ID_WS_VQA,
	CODEC_ID_MSRLE,
	CODEC_ID_MSVIDEO1,
	CODEC_ID_IDCIN,
	CODEC_ID_8BPS,
	CODEC_ID_SMC,
	CODEC_ID_FLIC,
	CODEC_ID_TRUEMOTION1,
	CODEC_ID_VMDVIDEO,
	CODEC_ID_MSZH,
	CODEC_ID_ZLIB,
	CODEC_ID_QTRLE,
	CODEC_ID_TSCC,
	CODEC_ID_ULTI,
	CODEC_ID_QDRAW,
	CODEC_ID_VIXL,
	CODEC_ID_QPEG,
	CODEC_ID_PNG,
	CODEC_ID_PPM,
	CODEC_ID_PBM,
	CODEC_ID_PGM,
	CODEC_ID_PGMYUV,
	CODEC_ID_PAM,
	CODEC_ID_FFVHUFF,
	CODEC_ID_RV30,
	CODEC_ID_RV40,
	CODEC_ID_VC1,
	CODEC_ID_WMV3,
	CODEC_ID_LOCO,
	CODEC_ID_WNV1,
	CODEC_ID_AASC,
	CODEC_ID_INDEO2,
	CODEC_ID_FRAPS,
	CODEC_ID_TRUEMOTION2,
	CODEC_ID_BMP,
	CODEC_ID_CSCD,
	CODEC_ID_MMVIDEO,
	CODEC_ID_ZMBV,
	CODEC_ID_AVS,
	CODEC_ID_SMACKVIDEO,
	CODEC_ID_NUV,
	CODEC_ID_KMVC,
	CODEC_ID_FLASHSV,
	CODEC_ID_CAVS,
	CODEC_ID_JPEG2000,
	CODEC_ID_VMNC,
	CODEC_ID_VP5,
	CODEC_ID_VP6,
	CODEC_ID_VP6F,
	CODEC_ID_TARGA,
	CODEC_ID_DSICINVIDEO,
	CODEC_ID_TIERTEXSEQVIDEO,
	CODEC_ID_TIFF,
	CODEC_ID_GIF,
	CODEC_ID_DXA,
	CODEC_ID_DNXHD,
	CODEC_ID_THP,
	CODEC_ID_SGI,
	CODEC_ID_C93,
	CODEC_ID_BETHSOFTVID,
	CODEC_ID_PTX,
	CODEC_ID_TXD,
	CODEC_ID_VP6A,
	CODEC_ID_AMV,
	CODEC_ID_VB,
	CODEC_ID_PCX,
	CODEC_ID_SUNRAST,
	CODEC_ID_INDEO4,
	CODEC_ID_INDEO5,
	CODEC_ID_MIMIC,
	CODEC_ID_RL2,
	CODEC_ID_ESCAPE124,
	CODEC_ID_DIRAC,
	CODEC_ID_BFI,
	CODEC_ID_CMV,
	CODEC_ID_MOTIONPIXELS,
	CODEC_ID_TGV,
	CODEC_ID_TGQ,
	CODEC_ID_TQI,
	CODEC_ID_AURA,
	CODEC_ID_AURA2,
	CODEC_ID_V210X,
	CODEC_ID_TMV,
	CODEC_ID_V210,
	CODEC_ID_DPX,
	CODEC_ID_MAD,
	CODEC_ID_FRWU,
	CODEC_ID_FLASHSV2,
	CODEC_ID_CDGRAPHICS,
	CODEC_ID_R210,
	CODEC_ID_ANM,
	CODEC_ID_BINKVIDEO,
	CODEC_ID_IFF_ILBM,
	CODEC_ID_IFF_BYTERUN1,
	CODEC_ID_KGV1,
	CODEC_ID_YOP,
	CODEC_ID_VP8,
	CODEC_ID_PICTOR,
	CODEC_ID_ANSI,
	CODEC_ID_A64_MULTI,
	CODEC_ID_A64_MULTI5,
	CODEC_ID_R10K,
	CODEC_ID_MXPEG,
	CODEC_ID_LAGARITH,
	CODEC_ID_PRORES,
	CODEC_ID_JV,
	CODEC_ID_DFA,
	CODEC_ID_WMV3IMAGE,
	CODEC_ID_VC1IMAGE,
	CODEC_ID_UTVIDEO,
	CODEC_ID_BMV_VIDEO,
	CODEC_ID_VBLE,
	CODEC_ID_DXTORY,
	CODEC_ID_V410,
	CODEC_ID_XWD,
	CODEC_ID_CDXL,
	CODEC_ID_XBM,
	CODEC_ID_ZEROCODEC,
	CODEC_ID_MSS1,
	CODEC_ID_MSA1,
	CODEC_ID_TSCC2,
	CODEC_ID_MTS2,
	CODEC_ID_CLLC,
	CODEC_ID_Y41P = 1496592720,
	CODEC_ID_ESCAPE130 = 1160852272,
	CODEC_ID_EXR = 809850962,
	CODEC_ID_AVRP = 1096176208,
	CODEC_ID_G2M = 4665933,
	CODEC_ID_AVUI = 1096176969,
	CODEC_ID_AYUV = 1096373590,
	CODEC_ID_V308 = 1446195256,
	CODEC_ID_V408 = 1446260792,
	CODEC_ID_YUV4 = 1498764852,
	CODEC_ID_SANM = 1396788813,
	CODEC_ID_PAF_VIDEO = 1346455126,
	CODEC_ID_SNOW = 1397641047,
	CODEC_ID_FIRST_AUDIO = 65536,
	CODEC_ID_PCM_S16LE = 65536,
	CODEC_ID_PCM_S16BE,
	CODEC_ID_PCM_U16LE,
	CODEC_ID_PCM_U16BE,
	CODEC_ID_PCM_S8,
	CODEC_ID_PCM_U8,
	CODEC_ID_PCM_MULAW,
	CODEC_ID_PCM_ALAW,
	CODEC_ID_PCM_S32LE,
	CODEC_ID_PCM_S32BE,
	CODEC_ID_PCM_U32LE,
	CODEC_ID_PCM_U32BE,
	CODEC_ID_PCM_S24LE,
	CODEC_ID_PCM_S24BE,
	CODEC_ID_PCM_U24LE,
	CODEC_ID_PCM_U24BE,
	CODEC_ID_PCM_S24DAUD,
	CODEC_ID_PCM_ZORK,
	CODEC_ID_PCM_S16LE_PLANAR,
	CODEC_ID_PCM_DVD,
	CODEC_ID_PCM_F32BE,
	CODEC_ID_PCM_F32LE,
	CODEC_ID_PCM_F64BE,
	CODEC_ID_PCM_F64LE,
	CODEC_ID_PCM_BLURAY,
	CODEC_ID_PCM_LXF,
	CODEC_ID_S302M,
	CODEC_ID_PCM_S8_PLANAR,
	CODEC_ID_ADPCM_IMA_QT = 69632,
	CODEC_ID_ADPCM_IMA_WAV,
	CODEC_ID_ADPCM_IMA_DK3,
	CODEC_ID_ADPCM_IMA_DK4,
	CODEC_ID_ADPCM_IMA_WS,
	CODEC_ID_ADPCM_IMA_SMJPEG,
	CODEC_ID_ADPCM_MS,
	CODEC_ID_ADPCM_4XM,
	CODEC_ID_ADPCM_XA,
	CODEC_ID_ADPCM_ADX,
	CODEC_ID_ADPCM_EA,
	CODEC_ID_ADPCM_G726,
	CODEC_ID_ADPCM_CT,
	CODEC_ID_ADPCM_SWF,
	CODEC_ID_ADPCM_YAMAHA,
	CODEC_ID_ADPCM_SBPRO_4,
	CODEC_ID_ADPCM_SBPRO_3,
	CODEC_ID_ADPCM_SBPRO_2,
	CODEC_ID_ADPCM_THP,
	CODEC_ID_ADPCM_IMA_AMV,
	CODEC_ID_ADPCM_EA_R1,
	CODEC_ID_ADPCM_EA_R3,
	CODEC_ID_ADPCM_EA_R2,
	CODEC_ID_ADPCM_IMA_EA_SEAD,
	CODEC_ID_ADPCM_IMA_EA_EACS,
	CODEC_ID_ADPCM_EA_XAS,
	CODEC_ID_ADPCM_EA_MAXIS_XA,
	CODEC_ID_ADPCM_IMA_ISS,
	CODEC_ID_ADPCM_G722,
	CODEC_ID_ADPCM_IMA_APC,
	CODEC_ID_VIMA = 1447644481,
	CODEC_ID_AMR_NB = 73728,
	CODEC_ID_AMR_WB,
	CODEC_ID_RA_144 = 77824,
	CODEC_ID_RA_288,
	CODEC_ID_ROQ_DPCM = 81920,
	CODEC_ID_INTERPLAY_DPCM,
	CODEC_ID_XAN_DPCM,
	CODEC_ID_SOL_DPCM,
	CODEC_ID_MP2 = 86016,
	CODEC_ID_MP3,
	CODEC_ID_AAC,
	CODEC_ID_AC3,
	CODEC_ID_DTS,
	CODEC_ID_VORBIS,
	CODEC_ID_DVAUDIO,
	CODEC_ID_WMAV1,
	CODEC_ID_WMAV2,
	CODEC_ID_MACE3,
	CODEC_ID_MACE6,
	CODEC_ID_VMDAUDIO,
	CODEC_ID_FLAC,
	CODEC_ID_MP3ADU,
	CODEC_ID_MP3ON4,
	CODEC_ID_SHORTEN,
	CODEC_ID_ALAC,
	CODEC_ID_WESTWOOD_SND1,
	CODEC_ID_GSM,
	CODEC_ID_QDM2,
	CODEC_ID_COOK,
	CODEC_ID_TRUESPEECH,
	CODEC_ID_TTA,
	CODEC_ID_SMACKAUDIO,
	CODEC_ID_QCELP,
	CODEC_ID_WAVPACK,
	CODEC_ID_DSICINAUDIO,
	CODEC_ID_IMC,
	CODEC_ID_MUSEPACK7,
	CODEC_ID_MLP,
	CODEC_ID_GSM_MS,
	CODEC_ID_ATRAC3,
	CODEC_ID_VOXWARE,
	CODEC_ID_APE,
	CODEC_ID_NELLYMOSER,
	CODEC_ID_MUSEPACK8,
	CODEC_ID_SPEEX,
	CODEC_ID_WMAVOICE,
	CODEC_ID_WMAPRO,
	CODEC_ID_WMALOSSLESS,
	CODEC_ID_ATRAC3P,
	CODEC_ID_EAC3,
	CODEC_ID_SIPR,
	CODEC_ID_MP1,
	CODEC_ID_TWINVQ,
	CODEC_ID_TRUEHD,
	CODEC_ID_MP4ALS,
	CODEC_ID_ATRAC1,
	CODEC_ID_BINKAUDIO_RDFT,
	CODEC_ID_BINKAUDIO_DCT,
	CODEC_ID_AAC_LATM,
	CODEC_ID_QDMC,
	CODEC_ID_CELT,
	CODEC_ID_G723_1,
	CODEC_ID_G729,
	CODEC_ID_8SVX_EXP,
	CODEC_ID_8SVX_FIB,
	CODEC_ID_BMV_AUDIO,
	CODEC_ID_RALF,
	CODEC_ID_IAC,
	CODEC_ID_ILBC,
	CODEC_ID_FFWAVESYNTH = 1179014995,
	CODEC_ID_SONIC = 1397706307,
	CODEC_ID_SONIC_LS = 1397706316,
	CODEC_ID_PAF_AUDIO = 1346455105,
	CODEC_ID_OPUS = 1330664787,
	CODEC_ID_FIRST_SUBTITLE = 94208,
	CODEC_ID_DVD_SUBTITLE = 94208,
	CODEC_ID_DVB_SUBTITLE,
	CODEC_ID_TEXT,
	CODEC_ID_XSUB,
	CODEC_ID_SSA,
	CODEC_ID_MOV_TEXT,
	CODEC_ID_HDMV_PGS_SUBTITLE,
	CODEC_ID_DVB_TELETEXT,
	CODEC_ID_SRT,
	CODEC_ID_MICRODVD = 1833195076,
	CODEC_ID_EIA_608 = 1664495672,
	CODEC_ID_JACOSUB = 1246975298,
	CODEC_ID_SAMI = 1396788553,
	CODEC_ID_REALTEXT = 1381259348,
	CODEC_ID_SUBVIEWER = 1400201814,
	CODEC_ID_FIRST_UNKNOWN = 98304,
	CODEC_ID_TTF = 98304,
	CODEC_ID_BINTEXT = 1112823892,
	CODEC_ID_XBIN = 1480739150,
	CODEC_ID_IDF = 4801606,
	CODEC_ID_OTF = 5198918,
	CODEC_ID_PROBE = 102400,
	CODEC_ID_MPEG2TS = 131072,
	CODEC_ID_MPEG4SYSTEMS,
	CODEC_ID_FFMETADATA = 135168,
};
char const *upipe_av_to_flow_def(enum AVCodecID);
enum AVCodecID upipe_av_from_flow_def(char const *);
struct upipe_mgr *upipe_avfsink_mgr_alloc(void);
struct upipe_mgr *upipe_avfsrc_mgr_alloc(void);
struct upipe_mgr *upipe_avcdec_mgr_alloc(void);
struct upipe_mgr *upipe_avcenc_mgr_alloc(void);
int uref_avcenc_get_codec_name(struct uref *, char const **);
int uref_avcenc_set_codec_name(struct uref *, char const *);
int uref_avcenc_delete_codec_name(struct uref *);
int uref_avcenc_match_codec_name(struct uref *, char const *);
int uref_avcenc_cmp_codec_name(struct uref *, struct uref *);
enum AVPixelFormat {
	AV_PIX_FMT_NONE = -129,
	AV_PIX_FMT_YUV420P = 0,
	AV_PIX_FMT_YUYV422,
	AV_PIX_FMT_RGB24,
	AV_PIX_FMT_BGR24,
	AV_PIX_FMT_YUV422P,
	AV_PIX_FMT_YUV444P,
	AV_PIX_FMT_YUV410P,
	AV_PIX_FMT_YUV411P,
	AV_PIX_FMT_GRAY8,
	AV_PIX_FMT_MONOWHITE,
	AV_PIX_FMT_MONOBLACK,
	AV_PIX_FMT_PAL8,
	AV_PIX_FMT_YUVJ420P,
	AV_PIX_FMT_YUVJ422P,
	AV_PIX_FMT_YUVJ444P,
	AV_PIX_FMT_XVMC_MPEG2_MC,
	AV_PIX_FMT_XVMC_MPEG2_IDCT,
	AV_PIX_FMT_UYVY422,
	AV_PIX_FMT_UYYVYY411,
	AV_PIX_FMT_BGR8,
	AV_PIX_FMT_BGR4,
	AV_PIX_FMT_BGR4_BYTE,
	AV_PIX_FMT_RGB8,
	AV_PIX_FMT_RGB4,
	AV_PIX_FMT_RGB4_BYTE,
	AV_PIX_FMT_NV12,
	AV_PIX_FMT_NV21,
	AV_PIX_FMT_ARGB,
	AV_PIX_FMT_RGBA,
	AV_PIX_FMT_ABGR,
	AV_PIX_FMT_BGRA,
	AV_PIX_FMT_GRAY16BE,
	AV_PIX_FMT_GRAY16LE,
	AV_PIX_FMT_YUV440P,
	AV_PIX_FMT_YUVJ440P,
	AV_PIX_FMT_YUVA420P,
	AV_PIX_FMT_VDPAU_H264,
	AV_PIX_FMT_VDPAU_MPEG1,
	AV_PIX_FMT_VDPAU_MPEG2,
	AV_PIX_FMT_VDPAU_WMV3,
	AV_PIX_FMT_VDPAU_VC1,
	AV_PIX_FMT_RGB48BE,
	AV_PIX_FMT_RGB48LE,
	AV_PIX_FMT_RGB565BE,
	AV_PIX_FMT_RGB565LE,
	AV_PIX_FMT_RGB555BE,
	AV_PIX_FMT_RGB555LE,
	AV_PIX_FMT_BGR565BE,
	AV_PIX_FMT_BGR565LE,
	AV_PIX_FMT_BGR555BE,
	AV_PIX_FMT_BGR555LE,
	AV_PIX_FMT_VAAPI_MOCO,
	AV_PIX_FMT_VAAPI_IDCT,
	AV_PIX_FMT_VAAPI_VLD,
	AV_PIX_FMT_YUV420P16LE,
	AV_PIX_FMT_YUV420P16BE,
	AV_PIX_FMT_YUV422P16LE,
	AV_PIX_FMT_YUV422P16BE,
	AV_PIX_FMT_YUV444P16LE,
	AV_PIX_FMT_YUV444P16BE,
	AV_PIX_FMT_VDPAU_MPEG4,
	AV_PIX_FMT_DXVA2_VLD,
	AV_PIX_FMT_RGB444LE,
	AV_PIX_FMT_RGB444BE,
	AV_PIX_FMT_BGR444LE,
	AV_PIX_FMT_BGR444BE,
	AV_PIX_FMT_YA8,
	AV_PIX_FMT_Y400A = 66,
	AV_PIX_FMT_GRAY8A = 66,
	AV_PIX_FMT_BGR48BE,
	AV_PIX_FMT_BGR48LE,
	AV_PIX_FMT_YUV420P9BE,
	AV_PIX_FMT_YUV420P9LE,
	AV_PIX_FMT_YUV420P10BE,
	AV_PIX_FMT_YUV420P10LE,
	AV_PIX_FMT_YUV422P10BE,
	AV_PIX_FMT_YUV422P10LE,
	AV_PIX_FMT_YUV444P9BE,
	AV_PIX_FMT_YUV444P9LE,
	AV_PIX_FMT_YUV444P10BE,
	AV_PIX_FMT_YUV444P10LE,
	AV_PIX_FMT_YUV422P9BE,
	AV_PIX_FMT_YUV422P9LE,
	AV_PIX_FMT_VDA_VLD,
	AV_PIX_FMT_GBRP,
	AV_PIX_FMT_GBRP9BE,
	AV_PIX_FMT_GBRP9LE,
	AV_PIX_FMT_GBRP10BE,
	AV_PIX_FMT_GBRP10LE,
	AV_PIX_FMT_GBRP16BE,
	AV_PIX_FMT_GBRP16LE,
	AV_PIX_FMT_YUVA422P_LIBAV,
	AV_PIX_FMT_YUVA444P_LIBAV,
	AV_PIX_FMT_YUVA420P9BE,
	AV_PIX_FMT_YUVA420P9LE,
	AV_PIX_FMT_YUVA422P9BE,
	AV_PIX_FMT_YUVA422P9LE,
	AV_PIX_FMT_YUVA444P9BE,
	AV_PIX_FMT_YUVA444P9LE,
	AV_PIX_FMT_YUVA420P10BE,
	AV_PIX_FMT_YUVA420P10LE,
	AV_PIX_FMT_YUVA422P10BE,
	AV_PIX_FMT_YUVA422P10LE,
	AV_PIX_FMT_YUVA444P10BE,
	AV_PIX_FMT_YUVA444P10LE,
	AV_PIX_FMT_YUVA420P16BE,
	AV_PIX_FMT_YUVA420P16LE,
	AV_PIX_FMT_YUVA422P16BE,
	AV_PIX_FMT_YUVA422P16LE,
	AV_PIX_FMT_YUVA444P16BE,
	AV_PIX_FMT_YUVA444P16LE,
	AV_PIX_FMT_VDPAU,
	AV_PIX_FMT_XYZ12LE,
	AV_PIX_FMT_XYZ12BE,
	AV_PIX_FMT_NV16,
	AV_PIX_FMT_NV20LE,
	AV_PIX_FMT_NV20BE,
	AV_PIX_FMT_RGBA64BE_LIBAV,
	AV_PIX_FMT_RGBA64LE_LIBAV,
	AV_PIX_FMT_BGRA64BE_LIBAV,
	AV_PIX_FMT_BGRA64LE_LIBAV,
	AV_PIX_FMT_YVYU422,
	AV_PIX_FMT_VDA,
	AV_PIX_FMT_YA16BE,
	AV_PIX_FMT_YA16LE,
	AV_PIX_FMT_GBRAP_LIBAV,
	AV_PIX_FMT_GBRAP16BE_LIBAV,
	AV_PIX_FMT_GBRAP16LE_LIBAV,
	AV_PIX_FMT_QSV,
	AV_PIX_FMT_RGBA64BE = 291,
	AV_PIX_FMT_RGBA64LE,
	AV_PIX_FMT_BGRA64BE,
	AV_PIX_FMT_BGRA64LE,
	AV_PIX_FMT_0RGB,
	AV_PIX_FMT_RGB0,
	AV_PIX_FMT_0BGR,
	AV_PIX_FMT_BGR0,
	AV_PIX_FMT_YUVA444P,
	AV_PIX_FMT_YUVA422P,
	AV_PIX_FMT_YUV420P12BE,
	AV_PIX_FMT_YUV420P12LE,
	AV_PIX_FMT_YUV420P14BE,
	AV_PIX_FMT_YUV420P14LE,
	AV_PIX_FMT_YUV422P12BE,
	AV_PIX_FMT_YUV422P12LE,
	AV_PIX_FMT_YUV422P14BE,
	AV_PIX_FMT_YUV422P14LE,
	AV_PIX_FMT_YUV444P12BE,
	AV_PIX_FMT_YUV444P12LE,
	AV_PIX_FMT_YUV444P14BE,
	AV_PIX_FMT_YUV444P14LE,
	AV_PIX_FMT_GBRP12BE,
	AV_PIX_FMT_GBRP12LE,
	AV_PIX_FMT_GBRP14BE,
	AV_PIX_FMT_GBRP14LE,
	AV_PIX_FMT_GBRAP,
	AV_PIX_FMT_GBRAP16BE,
	AV_PIX_FMT_GBRAP16LE,
	AV_PIX_FMT_YUVJ411P,
	AV_PIX_FMT_BAYER_BGGR8,
	AV_PIX_FMT_BAYER_RGGB8,
	AV_PIX_FMT_BAYER_GBRG8,
	AV_PIX_FMT_BAYER_GRBG8,
	AV_PIX_FMT_BAYER_BGGR16LE,
	AV_PIX_FMT_BAYER_BGGR16BE,
	AV_PIX_FMT_BAYER_RGGB16LE,
	AV_PIX_FMT_BAYER_RGGB16BE,
	AV_PIX_FMT_BAYER_GBRG16LE,
	AV_PIX_FMT_BAYER_GBRG16BE,
	AV_PIX_FMT_BAYER_GRBG16LE,
	AV_PIX_FMT_BAYER_GRBG16BE,
	AV_PIX_FMT_NB,
	PIX_FMT_NONE = -129,
	PIX_FMT_YUV420P = 0,
	PIX_FMT_YUYV422,
	PIX_FMT_RGB24,
	PIX_FMT_BGR24,
	PIX_FMT_YUV422P,
	PIX_FMT_YUV444P,
	PIX_FMT_YUV410P,
	PIX_FMT_YUV411P,
	PIX_FMT_GRAY8,
	PIX_FMT_MONOWHITE,
	PIX_FMT_MONOBLACK,
	PIX_FMT_PAL8,
	PIX_FMT_YUVJ420P,
	PIX_FMT_YUVJ422P,
	PIX_FMT_YUVJ444P,
	PIX_FMT_XVMC_MPEG2_MC,
	PIX_FMT_XVMC_MPEG2_IDCT,
	PIX_FMT_UYVY422,
	PIX_FMT_UYYVYY411,
	PIX_FMT_BGR8,
	PIX_FMT_BGR4,
	PIX_FMT_BGR4_BYTE,
	PIX_FMT_RGB8,
	PIX_FMT_RGB4,
	PIX_FMT_RGB4_BYTE,
	PIX_FMT_NV12,
	PIX_FMT_NV21,
	PIX_FMT_ARGB,
	PIX_FMT_RGBA,
	PIX_FMT_ABGR,
	PIX_FMT_BGRA,
	PIX_FMT_GRAY16BE,
	PIX_FMT_GRAY16LE,
	PIX_FMT_YUV440P,
	PIX_FMT_YUVJ440P,
	PIX_FMT_YUVA420P,
	PIX_FMT_VDPAU_H264,
	PIX_FMT_VDPAU_MPEG1,
	PIX_FMT_VDPAU_MPEG2,
	PIX_FMT_VDPAU_WMV3,
	PIX_FMT_VDPAU_VC1,
	PIX_FMT_RGB48BE,
	PIX_FMT_RGB48LE,
	PIX_FMT_RGB565BE,
	PIX_FMT_RGB565LE,
	PIX_FMT_RGB555BE,
	PIX_FMT_RGB555LE,
	PIX_FMT_BGR565BE,
	PIX_FMT_BGR565LE,
	PIX_FMT_BGR555BE,
	PIX_FMT_BGR555LE,
	PIX_FMT_VAAPI_MOCO,
	PIX_FMT_VAAPI_IDCT,
	PIX_FMT_VAAPI_VLD,
	PIX_FMT_YUV420P16LE,
	PIX_FMT_YUV420P16BE,
	PIX_FMT_YUV422P16LE,
	PIX_FMT_YUV422P16BE,
	PIX_FMT_YUV444P16LE,
	PIX_FMT_YUV444P16BE,
	PIX_FMT_VDPAU_MPEG4,
	PIX_FMT_DXVA2_VLD,
	PIX_FMT_RGB444LE,
	PIX_FMT_RGB444BE,
	PIX_FMT_BGR444LE,
	PIX_FMT_BGR444BE,
	PIX_FMT_GRAY8A,
	PIX_FMT_BGR48BE,
	PIX_FMT_BGR48LE,
	PIX_FMT_YUV420P9BE,
	PIX_FMT_YUV420P9LE,
	PIX_FMT_YUV420P10BE,
	PIX_FMT_YUV420P10LE,
	PIX_FMT_YUV422P10BE,
	PIX_FMT_YUV422P10LE,
	PIX_FMT_YUV444P9BE,
	PIX_FMT_YUV444P9LE,
	PIX_FMT_YUV444P10BE,
	PIX_FMT_YUV444P10LE,
	PIX_FMT_YUV422P9BE,
	PIX_FMT_YUV422P9LE,
	PIX_FMT_VDA_VLD,
	PIX_FMT_GBRP,
	PIX_FMT_GBRP9BE,
	PIX_FMT_GBRP9LE,
	PIX_FMT_GBRP10BE,
	PIX_FMT_GBRP10LE,
	PIX_FMT_GBRP16BE,
	PIX_FMT_GBRP16LE,
	PIX_FMT_RGBA64BE = 291,
	PIX_FMT_RGBA64LE,
	PIX_FMT_BGRA64BE,
	PIX_FMT_BGRA64LE,
	PIX_FMT_0RGB,
	PIX_FMT_RGB0,
	PIX_FMT_0BGR,
	PIX_FMT_BGR0,
	PIX_FMT_YUVA444P,
	PIX_FMT_YUVA422P,
	PIX_FMT_YUV420P12BE,
	PIX_FMT_YUV420P12LE,
	PIX_FMT_YUV420P14BE,
	PIX_FMT_YUV420P14LE,
	PIX_FMT_YUV422P12BE,
	PIX_FMT_YUV422P12LE,
	PIX_FMT_YUV422P14BE,
	PIX_FMT_YUV422P14LE,
	PIX_FMT_YUV444P12BE,
	PIX_FMT_YUV444P12LE,
	PIX_FMT_YUV444P14BE,
	PIX_FMT_YUV444P14LE,
	PIX_FMT_GBRP12BE,
	PIX_FMT_GBRP12LE,
	PIX_FMT_GBRP14BE,
	PIX_FMT_GBRP14LE,
	PIX_FMT_NB,
};
int upipe_av_pixfmt_to_flow_def(enum AVPixelFormat, struct uref *);
enum AVPixelFormat upipe_av_pixfmt_from_flow_def(struct uref *, enum AVPixelFormat const *, char const **);
enum AVSampleFormat {
	AV_SAMPLE_FMT_NONE = -129,
	AV_SAMPLE_FMT_U8 = 0,
	AV_SAMPLE_FMT_S16,
	AV_SAMPLE_FMT_S32,
	AV_SAMPLE_FMT_FLT,
	AV_SAMPLE_FMT_DBL,
	AV_SAMPLE_FMT_U8P,
	AV_SAMPLE_FMT_S16P,
	AV_SAMPLE_FMT_S32P,
	AV_SAMPLE_FMT_FLTP,
	AV_SAMPLE_FMT_DBLP,
	AV_SAMPLE_FMT_NB,
};
int upipe_av_samplefmt_to_flow_def(struct uref *, enum AVSampleFormat, uint8_t);
enum AVSampleFormat upipe_av_samplefmt_from_flow_def(struct uref *, uint8_t *);
]]
libupipe_av = ffi.load("libupipe_av.so", true)
libupipe_av_static = ffi.load("libupipe-av.static.so", true)
