DEFAULT_HOST!=../default-host.sh
HOST?=$(DEFAULT_HOST)
HOSTARCH!=../target-triplet-to-arch.sh $(HOST)

CFLAGS?=
LDFLAGS?=
LIBS?=

DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
INCLUDEDIR?=$(PREFIX)/include
LIBDIR?=$(PREFIX)/lib

CFLAGS:=$(CFLAGS) -ffreestanding --target=$(HOST) -Wall -Wextra -Werror
LIBK_CFLAGS:=$(CFLAGS) --target=$(HOST)

ARCHDIR=arch/$(HOSTARCH)
include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
LIBK_CFLAGS:=$(LIBK_CFLAGS) $(KERNEL_ARCH_CFLAGS)

FREEOBJS=$(ARCH_FREEOBJS) \
	 string/strlen.o \

HOSTEDOBJS=$(ARCH_HOSTEDOBJS) \
OBJS=$(FREEOBJS) \
     $(HOSTEDOBJS) \

LIBK_OBJS=$(FREEOBJS:.o=.libk.o)

# BINARIES=libc.a libk.a # Not ready for libc yet
BINARIES=libk.a

.PHONY: all clean install install-headers install-libs
.SUFFIXES: .o .libk.o .c .S

all: $(BINARIES)

libc.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

libk.a: $(LIBK_OBJS)
	$(AR) rcs $@ $(LIBK_OBJS)

.c.o:
	$(CC) -MD -c $< -o $@ -std=c11 $(CFLAGS)

.S.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS)

.c.libk.o:
	$(CC) -MD -c $< -o $@ -std=c11 $(LIBK_CFLAGS)

.S.libk.o:
	$(CC) -MD -c $< -o $@ $(LIBK_CFLAGS)

clean:
	rm -f mbos.kernel
	rm -f $(OBJS) *.o */*.o */*/*.o
	rm -rf $(OBJS:.o=.d)  *.d */*.d */*/*.d

install: install-headers install-libs

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-libs: $(BINARIES)
	mkdir -p $(DESTDIR)$(LIBDIR)
	cp $(BINARIES) $(DESTDIR)$(LIBDIR)

-include $(OBJS:.o=.d)
-include $(LIBK_OBJS:.o=.d)
