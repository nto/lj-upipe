local ffi = require("ffi")
ffi.cdef [[
enum uprobe_gl_sink_event {
	UPROBE_GL_SINK_SENTINEL = 32768,
	UPROBE_GL_SINK_INIT,
	UPROBE_GL_SINK_RENDER,
	UPROBE_GL_SINK_RESHAPE,
	UPROBE_GL_SINK_LOCAL,
};
typedef unsigned int GLuint;
bool upipe_gl_texture_load_uref(struct uref *, GLuint);
struct upipe_mgr *upipe_glx_sink_mgr_alloc(void);
bool upipe_glx_sink_init(struct upipe *, int, int, int, int);
]]
libupipe_gl = ffi.load("libupipe_gl.so.0", true)
libupipe_gl_static = ffi.load("libupipe-gl.static.so", true)
