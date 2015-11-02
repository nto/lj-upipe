PREFIX		= /usr
CC		= $(CROSS)gcc
CFLAGS		= -std=gnu11 -O2 -g
INCLUDE_DIR	= $(PREFIX)/include
LIB_DIR		= $(PREFIX)/lib
CPPFLAGS	= -I$(INCLUDE_DIR)
LUAJIT_DEST	= /usr/share/luajit-2.0.2

LIST = upipe \
       upipe-ts \
       upipe-modules \
       upipe-av \
       upipe-filters \
       upipe-framers \
       upipe-swscale \
       upipe-x264

STATIC_SO = $(LIST:%=lib%.static.so)
LIST_CDEF = $(LIST:%=cdef/%-cdef.lua) cdef/upipe-helper-cdef.lua
SIG_LUA = $(LIST:%=%-sigs.lua)
CDEF_LUA = $(LIST_CDEF) cdef/libev.lua cdef/upump-ev-cdef.lua
GETTERS_LUA = upipe-getters.lua uref-getters.lua
ARGS_LUA = uprobe-args.lua upipe-control-args.lua
SO = libffi-stdarg.so libupipe-helper.so

LUA_SRC = upipe.lua ffi-stdarg.lua $(CDEF_LUA) $(SIG_LUA) $(GETTERS_LUA) $(ARGS_LUA)

all: $(SO) $(STATIC_SO) $(LUA_SRC)

install: $(SO) $(STATIC_SO) $(LUA_SRC)
	mkdir -p $(DESTDIR)$(LIB_DIR)
	install $(SO) $(STATIC_SO) $(DESTDIR)$(LIB_DIR)
	mkdir -p $(DESTDIR)$(LUAJIT_DEST)
	install -m 644 $(LUA_SRC) $(DESTDIR)$(LUAJIT_DEST)

clean: $(LIST:%=clean-static-so-%)
	$(RM) $(SIG_LUA)
	$(RM) $(GETTERS_LUA)
	$(RM) $(LIST_CDEF)
	$(RM) $(SO)
	$(RM) upipe.defs
	$(RM) -r build-upipe-helper

#-------------------------------------------------------------------------------
# static so
#-------------------------------------------------------------------------------

define static-c
$1.static.c: $(wildcard $(INCLUDE_DIR)/,$1/*.h)
	@echo gen $$@
	@$(RM) -r build-$1/$1
	@mkdir -p build-$1/$1
	@mkdir -p build-$1/upipe
	@cp "$(INCLUDE_DIR)/$1"/* build-$1/$1
	@cp "$(INCLUDE_DIR)/upipe/uref_attr.h" build-$1/upipe
	@sed -e 's/^static inline /              /' \
	  -i build-$1/$1/*.h build-$1/upipe/uref_attr.h
	@{ cd build-$1 && for i in $1/*; do \
	  echo "#include <$$$$i>"; \
	done; } > $$@
endef

lib%.static.so: %.static.c
	@echo "cc $@ <- $<"
	@$(CC) $(CFLAGS) -Ibuild-$* $(CPPFLAGS) -shared -fPIC -o $@ $<

%-sigs.lua: %.static.c
	@echo gen $@
	@sed -n 's/^#define UPIPE_\(.*\)_SIGNATURE UBASE_FOURCC(\(.*\))/upipe_sig("\L\1\E", \2)/p' \
	  build-$*/$*/* > $@

$(foreach c,$(LIST),$(eval $(call static-c,$c)))

clean-static-so-%:
	$(RM) -r build-$*
	$(RM) $*.static.c lib$*.static.so

#-------------------------------------------------------------------------------
# cdef
#-------------------------------------------------------------------------------

lib_ts      = ts
lib_modules = modules
lib_av      = av
lib_filters = filters
lib_framers = framers
lib_swscale = sws
lib_x264    = x264

prefix_base    = upipe_ uprobe_ ubuf_ uref_ uchain_ upump_ ustring_ udict_  \
		 uclock_ umem_ uuri_ uqueue_ urequest_ ufifo_ ucookie_ \
		 urefcount_ ueventfd_ uring_ ubase_ urational_ uatomic_ \
		 ulifo_ upool_ ulist_ udeal_ ulog_

prefix_ts      = upipe_ts_ uref_ts_
prefix_modules = upipe_ uprobe_
prefix_av      = upipe_av uref_avcenc_
prefix_filters = upipe_
prefix_framers = upipe_
prefix_swscale = upipe_
prefix_x264    = upipe_

cdef/upipe-cdef.lua: libupipe.static.so libc.defs
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--write-defs upipe.defs \
		--enum ubase_err \
		--enum upipe_command \
		--enum uref_date_type \
		--enum uprobe_event \
		$(addprefix --prefix ,$(prefix_base)) \
		$(LIB_DIR)/libupipe.so.0 \
		libupipe.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

upipe.defs: cdef/upipe-cdef.lua

cdef/upipe-modules-cdef.lua: libupipe-modules.static.so upipe.defs libc.defs
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--enum 'uprobe_*' \
		$(addprefix --prefix ,$(prefix_modules)) \
		$(LIB_DIR)/libupipe_$(lib_modules).so.0 \
		libupipe-modules.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

cdef/upipe-%-cdef.lua: libupipe-%.static.so upipe.defs libc.defs
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--enum 'uprobe_$*_*' \
		$(addprefix --prefix ,$(prefix_$*)) \
		$(LIB_DIR)/libupipe_$(lib_$*).so.0 \
		libupipe-$*.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

#-------------------------------------------------------------------------------
# upipe-helper
#-------------------------------------------------------------------------------

build-upipe-helper/upipe/upipe_helper_upipe.h:
	@echo gen $@
	@$(RM) -r build-upipe-helper
	@mkdir -p build-upipe-helper/upipe
	@cp "$(INCLUDE_DIR)"/upipe/upipe_helper_* build-upipe-helper/upipe
	@sed -e 's/^static /       /' -i build-upipe-helper/upipe/*.h

libupipe-helper.so: CPPFLAGS := -Ibuild-upipe-helper $(CPPFLAGS)
libupipe-helper.so: build-upipe-helper/upipe/upipe_helper_upipe.h

cdef/upipe-helper-cdef.lua: libupipe-helper.so upipe.defs libc.defs
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--prefix upipe_helper_ \
		--struct upipe_helper_mgr \
		$<
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

#-------------------------------------------------------------------------------
# getters
#-------------------------------------------------------------------------------

%-getters.lua: $(LIST_CDEF)
	@echo gen $@
	@{ \
	  echo "return {"; \
	  sed -n -e 's/^int $*_\(\(.*_\)\?get_.*\)(struct $* \*, \([^,]*[^ ]\) *\*);$$/    \1 = "\3",/p' $^; \
	  echo "}"; \
	} > $@

#-------------------------------------------------------------------------------

lib%.so: %.c
	@echo "cc $@ <- $<"
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -shared -fPIC -o $@ $<

.DELETE_ON_ERROR:
