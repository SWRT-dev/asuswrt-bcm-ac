# SPDX-License-Identifier: GPL-2.0
# Top level Makefile for iproute2

ifeq ("$(origin V)", "command line")
VERBOSE = $(V)
endif
ifndef VERBOSE
VERBOSE = 0
endif

ifeq ($(VERBOSE),0)
MAKEFLAGS += --no-print-directory
endif

PREFIX?=/usr
# brcm: modify the LIBDIR, SBINDIR
LIBDIR?=$(PREFIX)/lib
SBINDIR=$(INSTALL_DIR)/bin
CONFDIR=$(INSTALL_DIR)/etc/iproute2
NETNS_RUN_DIR?=/var/run/netns
NETNS_ETC_DIR?=/etc/netns
DATADIR?=$(PREFIX)/share
HDRDIR?=$(PREFIX)/include/iproute2
DOCDIR?=$(DATADIR)/doc/iproute2
MANDIR?=$(DATADIR)/man
ARPDDIR?=/var/lib/arpd
# brcm: modify the KERNEL_INCLUDES and add LIBC_INCLUDE
KERNEL_INCLUDES:=$(KERNEL_DIR)/include $(KERNEL_DIR)/arch/$(ARCH)/include
LIBC_INCLUDE=$(KERNEL_DIR)/include/linux
BASH_COMPDIR?=$(DATADIR)/bash-completion/completions

# Path to db_185.h include
DBM_INCLUDE:=$(DESTDIR)/usr/include

SHARED_LIBS = y

DEFINES= -DRESOLVE_HOSTNAMES -DLIBDIR=\"$(LIBDIR)\"
ifneq ($(SHARED_LIBS),y)
DEFINES+= -DNO_SHARED_LIBS
endif

DEFINES+=-DCONFDIR=\"$(CONFDIR)\" \
         -DNETNS_RUN_DIR=\"$(NETNS_RUN_DIR)\" \
         -DNETNS_ETC_DIR=\"$(NETNS_ETC_DIR)\"

#options for decnet
ADDLIB+=dnet_ntop.o dnet_pton.o

#options for ipx
ADDLIB+=ipx_ntop.o ipx_pton.o

#options for mpls
ADDLIB+=mpls_ntop.o mpls_pton.o

CC := gcc
HOSTCC ?= $(CC)
DEFINES += -D_GNU_SOURCE
# Turn on transparent support for LFS
DEFINES += -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
CCOPTS = -O2
WFLAGS := -Wall -Wstrict-prototypes  -Wmissing-prototypes
WFLAGS += -Wmissing-declarations -Wold-style-definition -Wformat=2

ifeq ($(or $(findstring 2.6.33.19,$(LINUX_KERNEL)), $(findstring 2.6.36,$(LINUX_KERNEL)), $(findstring 4.1.27,$(LINUX_KERNEL)), $(findstring 4.1.51,$(LINUX_KERNEL)), $(findstring 4.1.52,$(LINUX_KERNEL))),)
DEFINES += -D__KERNEL_4_X__
endif

CFLAGS := $(WFLAGS) $(CCOPTS) -I../include -I../include/uapi $(DEFINES)
YACCFLAGS = -d -t -v

# brcm: only build lib ip tc misc
SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma man

# brcm: modify the libutil.a to libipr2util.a
LIBNETLINK=../lib/libipr2util.a ../lib/libnetlink.a
LDLIBS += $(LIBNETLINK)

all: config.mk
	@set -e; \
	for i in $(SUBDIRS); \
	do echo; echo $$i; $(MAKE) $(MFLAGS) -C $$i; done

help:
	@echo "Make Targets:"
	@echo " all                 - build binaries"
	@echo " clean               - remove products of build"
	@echo " distclean           - remove configuration and build"
	@echo " install             - install binaries on local machine"
	@echo " check               - run tests"
	@echo " cscope              - build cscope database"
	@echo " snapshot            - generate version number header"
	@echo ""
	@echo "Make Arguments:"
	@echo " V=[0|1]             - set build verbosity level"

config.mk:
	sh configure $(KERNEL_INCLUDE)

install: all
	install -m 0755 -d $(DESTDIR)$(SBINDIR)
	install -m 0755 -d $(DESTDIR)$(CONFDIR)
	install -m 0755 -d $(DESTDIR)$(ARPDDIR)
	install -m 0755 -d $(DESTDIR)$(HDRDIR)
	install -m 0755 -d $(DESTDIR)$(DOCDIR)/examples
	install -m 0755 -d $(DESTDIR)$(DOCDIR)/examples/diffserv
	install -m 0644 README.iproute2+tc $(shell find examples -maxdepth 1 -type f) \
		$(DESTDIR)$(DOCDIR)/examples
	install -m 0644 $(shell find examples/diffserv -maxdepth 1 -type f) \
		$(DESTDIR)$(DOCDIR)/examples/diffserv
	@for i in $(SUBDIRS);  do $(MAKE) -C $$i install; done
	install -m 0644 $(shell find etc/iproute2 -maxdepth 1 -type f) $(DESTDIR)$(CONFDIR)
	install -m 0755 -d $(DESTDIR)$(BASH_COMPDIR)
	install -m 0644 bash-completion/tc $(DESTDIR)$(BASH_COMPDIR)
	install -m 0644 include/bpf_elf.h $(DESTDIR)$(HDRDIR)

snapshot:
	echo "static const char SNAPSHOT[] = \""`date +%y%m%d`"\";" \
		> include/SNAPSHOT.h

clean:
	@for i in $(SUBDIRS) testsuite; \
	do $(MAKE) $(MFLAGS) -C $$i clean; done

clobber:
	touch config.mk
	$(MAKE) $(MFLAGS) clean
	rm -f config.mk cscope.*

distclean: clobber

check:
	cd testsuite && $(MAKE) && $(MAKE) alltests

cscope:
	cscope -b -q -R -Iinclude -sip -slib -smisc -snetem -stc

.EXPORT_ALL_VARIABLES:
