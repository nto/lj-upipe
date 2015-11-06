PREFIX			= /usr
LIBDIR			= $(PREFIX)/lib
CC			= $(CROSS)gcc
CFLAGS			= -std=gnu11 -O2 -g
CPPFLAGS		= -I$(UPIPE_INCLUDEDIR)
LUAJIT_DEST		= /usr/share/luajit-2.0.2
PKG_CONFIG		= pkg-config

UPIPE_INCLUDEDIR := $(shell $(PKG_CONFIG) libupipe --variable=includedir)
UPIPE_LIBDIR     := $(shell $(PKG_CONFIG) libupipe --variable=libdir)

LIST_C := $(shell $(PKG_CONFIG) --list-all | sed -n 's/^lib\(upipe\|upump\)_\(\S*\).*/\1-\2/p')
LIST   := upipe $(LIST_C)

STATIC_SO   = $(LIST:%=lib%.static.so)
LIST_CDEF   = $(LIST_C:%=%.lua) libupipe.lua upipe-helper.lua
SIG_LUA     = $(LIST:%=%-sigs.lua)
CDEF_LUA    = $(LIST_CDEF) libev.lua
GETTERS_LUA = upipe-getters.lua uref-getters.lua
ARGS_LUA    = uprobe-args.lua upipe-control-args.lua
SO          = libffi-stdarg.so libupipe-helper.so

SRC_LUA = upipe.lua ffi-stdarg.lua $(CDEF_LUA) $(SIG_LUA) $(GETTERS_LUA) $(ARGS_LUA)

all: $(SO) $(STATIC_SO) $(SRC_LUA)

install: $(SO) $(STATIC_SO) $(SRC_LUA)
	mkdir -p $(DESTDIR)$(LIBDIR)
	install $(SO) $(STATIC_SO) $(DESTDIR)$(LIBDIR)
	mkdir -p $(DESTDIR)$(LUAJIT_DEST)
	install -m 644 $(SRC_LUA) $(DESTDIR)$(LUAJIT_DEST)

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
$1.static.c: $(wildcard $(UPIPE_INCLUDEDIR)/$1/*.h) $(UPIPE_INCLUDEDIR)/upipe/uref_attr.h
	@echo gen $$@
	@$(RM) -r build-$1/$1
	@mkdir -p build-$1/$1
	@mkdir -p build-$1/upipe
	@cp "$(UPIPE_INCLUDEDIR)/$1"/*.h build-$1/$1
	@cp "$(UPIPE_INCLUDEDIR)/upipe/uref_attr.h" build-$1/upipe
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

prefix_base    = upipe_ uprobe_ ubuf_ uref_ uchain_ upump_ ustring_ udict_  \
		 uclock_ umem_ uuri_ uqueue_ urequest_ ufifo_ ucookie_ \
		 urefcount_ ueventfd_ uring_ ubase_ urational_ uatomic_ \
		 ulifo_ upool_ ulist_ udeal_ ulog_

prefix_modules    = upipe_ uprobe_
prefix_ts         = upipe_ts_ uref_ts_
prefix_av         = upipe_av uref_avcenc_

libupipe = $(UPIPE_LIBDIR)/libupipe
libupump = $(UPIPE_LIBDIR)/libupump

libupipe.lua: libc.defs $(libupipe).so.0 libupipe.static.so
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
		$(libupipe).so.0 \
		libupipe.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

upipe.defs: libupipe.lua

upipe-modules.lua: libc.defs upipe.defs $(libupipe)_modules.so.0 libupipe-modules.static.so
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--enum 'uprobe_*' \
		$(addprefix --prefix ,$(prefix_modules)) \
		$(libupipe)_modules.so.0 \
		libupipe-modules.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

upipe-%.lua: libc.defs upipe.defs $(libupipe)_%.so.0 libupipe-%.static.so
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--enum 'uprobe_$*_*' \
		$(addprefix --prefix ,$(or $(prefix_$*),upipe_)) \
		$(libupipe)_$*.so.0 \
		libupipe-$*.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

upump-%.lua: libc.defs upipe.defs $(libupump)_%.so.0 libupump-%.static.so
	@echo gen $@
	@gen-ffi-cdef \
		--global \
		--output $@ \
		--read-defs libc.defs \
		--read-defs upipe.defs \
		--prefix upump_$*_ \
		$(libupump)_$*.so.0 \
		libupump-$*.static.so
	@sed 's/struct __va_list_tag \*/va_list/' -i $@

#-------------------------------------------------------------------------------
# upipe-helper
#-------------------------------------------------------------------------------

UPIPE_HELPERS = $(wildcard $(UPIPE_INCLUDEDIR)/upipe/upipe_helper_*)

build-upipe-helper/upipe/upipe_helper_upipe.h: $(UPIPE_HELPERS)
	@echo gen $@
	@$(RM) -r build-upipe-helper
	@mkdir -p build-upipe-helper/upipe
	@cp $(UPIPE_HELPERS) build-upipe-helper/upipe
	@sed -e 's/^static /       /' -i build-upipe-helper/upipe/*.h

libupipe-helper.so: CPPFLAGS := -Ibuild-upipe-helper $(CPPFLAGS)
libupipe-helper.so: build-upipe-helper/upipe/upipe_helper_upipe.h

upipe-helper.lua: libupipe-helper.so upipe.defs libc.defs
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
