include ../common.mak
CFLAGS	+= -I. -I$(TOP)/shared -I$(SRCBASE)/include -I$(SRCBASE)/common/include -Wall -Werror
CFLAGS	+= $(if $(WLAN_ComponentIncPath),$(WLAN_ComponentIncPath),$(addprefix -I,$(wildcard $(SRCBASE)/shared/bcmwifi/include)))
# CFLAGS	+= -DSSD_DEBUG
CFLAGS	+= -s -O2
LDFLAGS += -L$(TOP)/nvram${BCMEX} -L$(INSTALLDIR)/nvram/usr/lib -lnvram
LDFLAGS += -L$(TOP)/shared -L$(INSTALLDIR)/shared/usr/lib -lshared
LDFLAGS += $(EXTRA_LDFLAGS)
LDFLAGS += -lgcc_s


vpath %.c $(SRCBASE)/shared $(WLAN_ComponentSrcDirs)

ifeq ($(wildcard $(SRCBASE)/router/ssd/*.c),)
all:
	-cp -f prebuilt/ssd ssd
else
all: ssd
endif

OBJS = ssd.o

install: all
	install -d $(INSTALLDIR)/usr/sbin/
	install ssd $(INSTALLDIR)/usr/sbin/
	$(STRIP) $(INSTALLDIR)/usr/sbin/ssd

clean:
	rm -f *.o *.a *.so ssd

${OBJS}: ssd.h

ssd: ${OBJS}
	$(CC) $(CFLAGS) $^ -o $@  $(LDFLAGS)
