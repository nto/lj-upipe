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
       upipe-swscale \
       upipe-x264

STATIC_SO = $(LIST:%=lib%.static.so)
SIG_LUA = $(LIST:%=%_sig.lua)
CDEF_LUA = $(wildcard cdef/*.lua)

LUA_SRC = upipe.lua $(CDEF_LUA) $(SIG_LUA)

all: $(STATIC_SO) $(LUA_SRC)

install: $(STATIC_SO) $(LUA_SRC)
	mkdir -p $(DESTDIR)$(LIB_DIR)
	install $(STATIC_SO) $(DESTDIR)$(LIB_DIR)
	mkdir -p $(DESTDIR)$(LUAJIT_DEST)
	install $(LUA_SRC) $(DESTDIR)$(LUAJIT_DEST)

clean: $(LIST:%=clean-static-so-%)
	$(RM) $(SIG_LUA)

define static-c
$1.static.c: $(wildcard $(INCLUDE_DIR)/,$1/*.h)
	$(RM) -r build-$1/$1
	mkdir -p build-$1/$1
	mkdir -p build-$1/upipe
	cp "$(INCLUDE_DIR)/$1"/* build-$1/$1
	cp "$(INCLUDE_DIR)/upipe/uref_attr.h" build-$1/upipe
	sed -e 's/^static inline /              /' \
	  -i build-$1/$1/*.h build-$1/upipe/uref_attr.h
	{ cd build-$1 && for i in $1/*; do \
	  echo "#include <$$$$i>"; \
	done; } > $$@
endef

lib%.static.so: %.static.c
	$(CC) $(CFLAGS) -Ibuild-$* $(CPPFLAGS) -shared -fPIC -o $@ $<

%_sig.lua: %.static.c
	sed -n 's/^#define UPIPE_\(.*\)_SIGNATURE UBASE_FOURCC(\(.*\))/upipe_sig("\L\1\E", \2)/p' \
	  build-$*/$*/* > $@

$(eval $(call static-c,upipe))
$(eval $(call static-c,upipe-ts))
$(eval $(call static-c,upipe-modules))
$(eval $(call static-c,upipe-av))
$(eval $(call static-c,upipe-filters))
$(eval $(call static-c,upipe-swscale))
$(eval $(call static-c,upipe-x264))

clean-static-so-%:
	$(RM) -r build-$*
	$(RM) $*.static.c lib$*.static.so
