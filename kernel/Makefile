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
BOOTDIR?=$(PREFIX)/boot

CFLAGS:=$(CFLAGS) -ffreestanding --target=$(HOST) -Wall -Wextra -Werror
LDFLAGS:=$(LDFLAGS) -static --target=$(HOST) -fuse-ld=lld
LIBS:=$(LIBS) -nostdlib -lk -L $(SYSROOT)$(LIBDIR)

ARCHDIR=arch/$(HOSTARCH)
include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

KERNEL_OBJS=$(KERNEL_ARCH_OBJS) \
	   kernel/kernel.o \

OBJS=$(KERNEL_OBJS)

LINK_LIST=$(LDFLAGS) \
	  $(KERNEL_OBJS) \
	  $(LIBS)

BINARY=mbos.kernel

.PHONY: all clean install install-headers install-kernel
.SUFFIXES: .o .c .S

all: $(BINARY)

$(BINARY): $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot $(BINARY)

.c.o:
	$(CC) -MD -c $< -o $@ -std=c11 $(CFLAGS)

.S.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS)

clean:
	rm -f $(BINARY)
	rm -f $(OBJS) *.o */*.o */*/*.o
	rm -rf $(OBJS:.o=.d)  *.d */*.d */*/*.d

install: install-headers install-kernel

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-kernel: $(BINARY)
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp $(BINARY) $(DESTDIR)$(BOOTDIR)

-include $(OBJS:.o=.d)
