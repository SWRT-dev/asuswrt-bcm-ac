include ../common.mak

CFLAGS += -I. -I$(TOP)/shared -I$(SRCBASE)/include
LDFLAGS += -L$(TOP_PLATFORM)/nvram -lnvram 
LDFLAGS +=-L$(TOP)/shared -lshared
ifeq ($(RTCONFIG_HTTPS),y)
#CFLAGS += -I$(TOP)/openssl/include
LDFLAGS += -L$(TOP)/openssl -lcrypto -lssl
endif


EXEC = ated
SRCS = ated.c

#EXTRA_CFLAGS += -DDBG

ifneq ($(wildcard ./prebuild),)
all:
	-cp prebuild/$(EXEC) $(EXEC)
else
all: $(EXEC)
endif

$(EXEC): $(SRCS) $(LINUXDIR)/include/linux/autoconf.h
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(LDFLAGS) -o $@ $@.c

install: all
	install -D $(EXEC) $(INSTALLDIR)/bin/$(EXEC)
	$(STRIP) $(INSTALLDIR)/bin/$(EXEC)
	chmod 0500 $(INSTALLDIR)/bin/$(EXEC)

clean:
	-rm -f $(EXEC) *.o

