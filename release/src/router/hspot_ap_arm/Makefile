#Linux Makefile

#test merge

#SRCBASE = ../..
WLAN_ComponentsInUse := bcmwifi ppr olpc
#include ../../makefiles/WLAN_Common.mk
include ../../../src-rt-6.x.4708/makefiles/WLAN_Common.mk
#SRCBASE := $(WLAN_SrcBaseR)

include $(SRCBASE)/router/.config

INCLUDE += -I$(SRCBASE)/hspot/include -I$(SRCBASE)/hspot/dsp -I$(SRCBASE)/hspot/wlan -I$(SRCBASE)/hspot/tcp_srv -I$(SRCBASE)/hspot/pkt -I$(SRCBASE)/hspot/pro
INCLUDE += -I. -I.. -I$(SRCBASE)/include -I$(SRCBASE)/common/include -I$(SRCBASE)/shared -I$(SRCBASE)/router/shared -I$(SRCBASE)/wl/exe
INCLUDE += -I$(SRCBASE)/security/secfrw/include -I$(SRCBASE)/supp/include $(WLAN_ComponentIncPathR)
INCLUDE += -I$(SRCBASE)/wl/clm/include

CFLAGS += $(INCLUDE)
CFLAGS += -DWIFI_ACT_FRAME -DHOTSPOT_AP -DWNM_BSSTRANS_SUPPORT -DWLTDLS -Wall

CFLAGS  += -s

CFLAGS += -DPPR_API

#CFLAGS += -c -g -m32 -Wextra -Werror
#LDFLAGS += -m32 --cref -lpthread -lrt
#LDFLAGS += -Wl,-Map,hspotap.map

#LDFLAGS += -L$(TOP)/nvram -L$(INSTALLDIR)/nvram/usr/lib -lnvram
#LDFLAGS += -L$(TOP)/shared -L$(INSTALLDIR)/shared/usr/lib -lshared
LDFLAGS += -lgcc_s
LDFLAGS += -L$(TOP)/nvram${BCMEX} -lnvram -L$(TOP)/shared -lshared

LDFLAGS += $(EXTRA_LDFLAGS)

vpath %.c $(SRCBASE)/wl/exe
vpath %.c $(SRCBASE)/shared
vpath %.c $(SRCBASE)/shared/bcmwifi/src
vpath %.c $(SRCBASE)/security/secfrw/tmr
vpath %.c $(SRCBASE)/security/secfrw/utils
vpath %.c $(SRCBASE)/router/hspot_ap${BCMEX}
vpath %.c $(SRCBASE)/hspot/util
vpath %.c $(SRCBASE)/hspot/pkt
vpath %.c $(SRCBASE)/hspot/dsp
vpath %.c $(SRCBASE)/hspot/wlan
vpath %.c $(SRCBASE)/hspot/pro
vpath %.c $(SRCBASE)/hspot/tcp_srv
vpath %.c $(WLAN_ComponentSrcDirsR)

OBJS = trace.o
OBJS += bcm_encode.o bcm_decode.o
OBJS += bcm_encode_ie.o bcm_decode_ie.o bcm_decode_p2p.o
OBJS += bcm_encode_gas.o bcm_decode_gas.o
OBJS += bcm_encode_anqp.o bcm_decode_anqp.o
OBJS += bcm_encode_hspot_anqp.o bcm_decode_hspot_anqp.o
OBJS += bcm_encode_wnm.o bcm_decode_wnm.o
OBJS += dsp_ap.o tmr.o
OBJS += wlu_api.o wlu_linux_api.o
OBJS += wlu.o wlu_common.o wlu_cmd.o wlu_iov.o miniopt.o bcmwifi_channels.o bcmutils.o wlu_rates_matrix.o wlc_ppr.o
OBJS += bcm_app_utils.o bcmseclib_linux_timer.o bcmseclib_timer.o bcm_llist.o
OBJS += bcm_gas.o
OBJS += bcmevent.o
OBJS += hspotap.o
OBJS += tcp_srv.o

all: hspotap

ifneq ($(wildcard ./prebuilt),)
hspotap:
	cp prebuilt/hspotap .
else
hspotap: $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
endif

install: all
	install -d $(INSTALLDIR)/bin
	install hspotap $(INSTALLDIR)/bin
#	install 1357161475_wifi $(INSTALLDIR)/bin
	$(STRIP) $(INSTALLDIR)/bin/hspotap

clean:
	rm -f *.o *.map hspotap
