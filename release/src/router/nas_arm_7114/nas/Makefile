#
# 802.1x Authenticator (Network Access Server) Embedded Linux Build Makefile
#
# Copyright (C) 2014, Broadcom Corporation
# All Rights Reserved.
#

include ../../.config

CFLAGS	+= -I.. -I$(SRCBASE)/include ${WLAN_StdIncPathA} -I$(SRCBASE)/common/include -I$(SRCBASE)/router/shared -Wall 
CFLAGS	+= $(WLAN_ComponentIncPath)

#CFLAGS	+= -g -DDEBUG
CFLAGS += -DBCMDBG
CFLAGS	+= -s
CFLAGS  += -DNAS_WKSP_BUILD_NAS_AUTH
CFLAGS  += -DNAS_WKSP_BUILD_NAS_SUPPL
#CFLAGS  += -DNAS_GTK_PER_STA
CFLAGS  += -DNAS_RADIUS
CFLAGS  += -DNAS_WKSP_ON_DEMAND
ifeq ($(RTCONFIG_IPV6),y)
CFLAGS += -DNAS_IPV6
endif

CFLAGS	+= -DBCMSUPPL

# EAPD include path
CFLAGS	+= -I$(SRCBASE)/router/eapd${BCMEX}$(EX7)

LDFLAGS += -L$(TOP_PLATFORM)/nvram${BCMEX}${EX7} -L$(INSTALLDIR)/nvram/usr/lib -lnvram ${EXTRA_NV_LDFLAGS}
LDFLAGS += -L$(TOP)/shared -L$(INSTALLDIR)/shared/usr/lib -lshared
LDFLAGS += -L$(TOP)/libbcmcrypto -L$(INSTALLDIR)/libbcmcrypto/usr/lib -lbcmcrypto
LDFLAGS += -lgcc_s

ifeq ($(RTCONFIG_QTN),y)
LDFLAGS += -L$(TOP)/libqcsapi_client -lqcsapi_client
endif

vpath %.c $(SRCBASE)/router/nas${BCMEX}$(EX7) $(SRCBASE)/shared $(SRCBASE)/router/shared

# build target
NASOBJS = mppe.o wpa.o nas.o nas_linux.o nas_wl.o nas_wksp.o
NASOBJS += nas_radius.o nas_wksp_radius.o
UTLOBJS = bcmwpa.o bcmutils.o

ifeq ($(wildcard ../*.c), )
all:
	-cp ./prebuilt/nas .
else
all: nas
endif

nas: $(NASOBJS) $(UTLOBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

# install to target
install: all
	install -D nas $(INSTALLDIR)/usr/sbin/nas
	$(STRIP) $(INSTALLDIR)/usr/sbin/nas

# clean up mess
clean:
	rm -f *.o *~ nas
