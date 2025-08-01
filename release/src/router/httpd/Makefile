include ../common.mak

CFLAGS += -Os -Wall $(EXTRACFLAGS)
CFLAGS += $(PRIVATE_EXTRACFLAGS)
CFLAGS += -I$(SRCBASE) -I.
ifeq ($(RTCONFIG_BCM7),y)
CFLAGS += -I$(SRCBASE)/../../dhd/src/wl/exe/
endif
ifeq ($(RTCONFIG_BCM_7114),y)
CFLAGS += -I$(SRCBASE)/../dhd/src/include
CFLAGS += -I$(SRCBASE)/../dhd/src/shared/bcmwifi/include
endif
ifeq ($(RTCONFIG_BCM9),y)
CFLAGS += -I$(SRCBASE)/../sys/src/include/
endif
ifeq ($(HND_ROUTER),y)
CFLAGS += -I$(SRCBASE)/../../dhd/src/include/
CFLAGS += -I$(SRCBASE)/../../dhd/src/shared/bcmwifi/include/
CFLAGS += -I$(SRCBASE)/../../dhd/components/shared/devctrl_if/
endif
CFLAGS += -I$(SRCBASE)/include -I$(TOP)/shared -I$(TOP)/zlib -I$(TOP)/networkmap
ifneq ($(or $(RTCONFIG_BCM7),$(RTCONFIG_BCM_7114),$(RTCONFIG_BCM9),$(HND_ROUTER)),y)
ifeq ($(RTCONFIG_BCMWL6),y)
CFLAGS += -I$(SRCBASE)/wl/exe/
endif
endif
CFLAGS += -DASUS_DDNS -DTRANSLATE_ON_FLY -DFLASH_EMULATOR -DLinux -DWSC 

ifeq ($(RTCONFIG_NETOOL),y)
CFLAGS += -I$(TOP)/rc
endif

ifeq ($(RTCONFIG_VPN_FUSION),y)
CFLAGS += -I$(TOP)/rc
endif

ifeq ($(RTCONFIG_BCM_7114),y)
CFLAGS += -I$(SRCBASE)/../dhd/components/shared/
endif

ifeq ($(RTCONFIG_RALINK),y)
CFLAGS += -DRalink_WPS
CFLAGS += -I$(TOP)/shared/sysdeps/ralink -I$(TOP)/wireless_tools
endif

ifeq ($(RTCONFIG_QCA),y)
CFLAGS += -DQCA_WPS
CFLAGS += -I$(TOP)/shared/sysdeps/qca -I$(TOP)/wireless_tools
endif

ifeq ($(CONFIG_REALTEK),y)
CFLAGS += -I$(TOP)/shared/sysdeps/realtek
endif

ifeq ($(RTCONFIG_ALPINE),y)
CFLAGS += -DALPINE_WPS
CFLAGS += -I$(TOP)/httpd/sysdeps -I$(TOP)/shared/sysdeps/alpine -I$(TOP)/wireless_tools
endif
ifeq ($(RTCONFIG_LANTIQ),y)
CFLAGS += -DLANTIQ_WPS
CFLAGS += -I$(TOP)/shared/sysdeps/lantiq -I$(TOP)/wireless_tools
endif

ifeq ($(RTN11P)$(RTN300),y)
CFLAGS += -DBAND_2G_ONLY
endif

ifeq ($(RTN14U),y)
CFLAGS += -DBAND_2G_ONLY
endif

ifeq ($(RTN14U)$(RTAC52U)$(RTAC51U)$(RTN11P)$(RTN300)$(RTN54U)$(RTAC1200HP)$(RTN56UB1)$(RTN56UB2)$(RTAC54U)$(RTAC1200)$(RTAC1200V2)$(RTAC1200GA1)$(RTAC1200GU),y)
CFLAGS += -DRA_ESW
endif

ifeq ($(BUILD_NAME), RT-AC1200_V2)
CFLAGS += -DRTAC1200V2
endif

ifeq ($(RTCONFIG_DNSMASQ),y)
CFLAGS += -DDNSMASQ
endif

ifeq ($(RTCONFIG_BWDPI),y)
CFLAGS += -I$(TOP)/sqlite
CFLAGS += -I$(TOP)/bwdpi_source/src/tdts_udb_sample
CFLAGS += -I$(TOP)/bwdpi_source/src/tdts_udb_sample/linux
CFLAGS += -I$(TOP)/bwdpi_source/include
CFLAGS += -I$(TOP)/bwdpi_source/asus_include
endif

ifeq ($(RTCONFIG_TRAFFIC_LIMITER),y)
CFLAGS += -I$(TOP)/traffic_limiter
CFLAGS += -I$(TOP)/sqlite
endif

ifeq ($(RTCONFIG_SW_HW_AUTH), y)
CFLAGS += -I$(TOP)/sw-hw-auth
endif

ifeq ($(or $(RTAC68A),$(RT4GAC68U)),y)
CFLAGS += -DRTAC68U
endif

ifeq ($(RTCONFIG_CAPTCHA),y)
CFLAGS += -DCAPTCHA
endif

ifneq ($(findstring CONFIG_BCM_KF_NETFILTER=, $(shell cat $(LINUXDIR)/.config)),)
export CFLAGS += -DBCM_KF_NETFILTER
endif

OBJS = httpd.o cgi.o ej.o 
OBJS += web.o common.o nvram_f.o 
OBJS += aspbw.o initial_web_hook.o
OBJS += apps.o

ifeq ($(CONFIG_REALTEK),y)
OBJS += web-realtek.o
else ifeq ($(CONFIG_RALINK),y)
OBJS += web-ralink.o
else ifeq ($(CONFIG_QCA),y)
OBJS += web-qca.o
else ifeq ($(CONFIG_ALPINE),y)
OBJS += web-alpine.o
else ifeq ($(CONFIG_LANTIQ),y)
OBJS += $(if $(wildcard sysdeps/web-lantiq.c),web-lantiq.o,prebuild/web-lantiq.o)
else
ifeq ($(or $(RTCONFIG_HND_ROUTER_AX_675X),$(RTCONFIG_HND_ROUTER_AX_6756),$(RTCONFIG_HND_ROUTER_AX_6710),$(RTCONFIG_BCM_502L07P2)),y)
OBJS += $(if $(wildcard sysdeps/web-broadcom_private.c),web-broadcom_private.o,prebuild/web-broadcom_private.o)
endif
OBJS += $(if $(wildcard sysdeps/web-broadcom.c),web-broadcom.o,prebuild/web-broadcom.o)
ifeq ($(RTCONFIG_QTN),y)
OBJS += find_host_addr.o
endif
endif

ifeq ($(RTCONFIG_QSR10G),y)
OBJS += web-qsr10g.o
endif

ifeq ($(RTCONFIG_DSL),y)
OBJS += web-dsl.o
ifeq ($(RTCONFIG_RALINK),y)
OBJS += web-dsl-upg.o
endif
endif

ifeq ($(RTCONFIG_GEOIP),y)
OBJS += geoiplookup.o
endif

ifeq ($(RTCONFIG_EXT_RTL8365MB),y)
CFLAGS += -I$(LINUXDIR)/drivers/char/rtl8365mb
endif

ifeq ($(and $(HND_ROUTER),$(RTCONFIG_VISUALIZATION)),y)
OBJS += vis_gui.o
endif

ifeq ($(RTCONFIG_HTTPS),y)
OBJS += $(if $(wildcard pwenc.c), pwenc.o, prebuild/pwenc.o)
endif

OBJS += sysinfo.o
OBJS += swrt.o
ifeq ($(RTCONFIG_SOFTCENTER),y)
OBJS += dbapi.o
endif
ifeq ($(RTCONFIG_CAPTCHA),y)
OBJS += libcaptcha.o
endif

OBJS += $(if $(wildcard web_hook.c), web_hook.o, prebuild/web_hook.o)

LIBS = -L$(TOP_PLATFORM)/nvram${BCMEX}$(EX7) -lnvram -L$(TOP)/shared -lshared
ifeq ($(RTCONFIG_BCM_502L07P2),y)
LIBS += -L$(TOP_PLATFORM)/ethctl_lib -lethctl
endif
ifeq ($(HND_ROUTER),y)
LIBS += -L$(TOP_PLATFORM)/wlcsm -lwlcsm
endif

ifeq ($(or $(RTCONFIG_HND_ROUTER_AX_6756),$(RTCONFIG_BCM_502L07P2)),y)
LIBS += -L$(TOP_PLATFORM)/bcm_flashutil -lbcm_flashutil -L$(TOP_PLATFORM)/gen_util -lgen_util -L$(TOP_PLATFORM)/sys_util -lsys_util -L$(TOP_PLATFORM)/bcm_util -lbcm_util -L$(TOP_PLATFORM)/bcm_boardctl -lbcm_boardctl
endif

# for ceil()
LIBS += -lm

ifeq ($(RTCONFIG_PUSH_EMAIL),y)
CFLAGS += -I$(TOP)/openssl/include
LIBS += -L$(TOP)/openssl -lcrypto -lssl -ldl
endif

ifeq ($(RTCONFIG_BCMARM),y)
CFLAGS += -I$(SRCBASE)/shared/bcmwifi/include -DTYPEDEF_FLOAT_T
CFLAGS += -I$(SRCBASE)/common/include
ifeq ($(HND_ROUTER_AX),y)
CFLAGS += -DWL11AC_80P80 -DWL11AC_160
CFLAGS += -I$(SRCBASE)/../components/wlioctl/include -I$(SRCBASE)/../components/proto/include
CFLAGS += -I$(SRCBASE)/wl/sys
CFLAGS += -I$(SRCBASE)/../../43684/src/wl/sys
endif
LIBS += -lgcc_s
ifeq ($(or $(RTCONFIG_HND_ROUTER_AX_6756),$(RTCONFIG_BCM_502L07P2)),y)
CFLAGS += -I$(TOP_PLATFORM)/bcm_flashutil -I$(HND_SRC)/userspace/public/include -I$(HND_SRC)/userspace/public/include/linux 
endif
ifeq ($(RTCONFIG_QTN),y)
CFLAGS += -I$(TOP)/libqcsapi_client -I$(TOP)/shared/sysdeps/qtn
LIBS += -L$(TOP)/libqcsapi_client -lqcsapi_client
endif
endif

ifeq ($(RTCONFIG_AMAS),y)
LDFLAGS += -L$(TOP)/json-c/.libs -ljson-c
endif

ifeq ($(RTCONFIG_USB),y)
CFLAGS += -I$(TOP)/libdisk	
LIBS += -L$(TOP)/libdisk -ldisk
ifeq ($(RTCONFIG_USB_SMS_MODEM),y)
CFLAGS += -I$(TOP)/smspdu
LIBS += -L$(TOP)/smspdu -lsmspdu
endif
endif

ifeq ($(RTCONFIG_HTTPS),y)
CFLAGS += -I$(TOP)/mssl
CFLAGS += -I$(TOP)/openssl/include
LIBS += -L$(TOP)/mssl -lmssl
LIBS += -L$(TOP)/openssl -lssl -lcrypto -ldl
endif

ifeq ($(RTCONFIG_OPENVPN),y)
CFLAGS += -I$(TOP)/libvpn
LIBS += -L$(TOP)/libvpn -lvpn
LIBS += -L$(TOP)/openssl -lssl -lcrypto -ldl
endif

CFLAGS += -I$(TOP)/json-c
LIBS += -L$(TOP)/json-c/.libs -ljson-c

ifeq ($(RTCONFIG_BWDPI),y)
LIBS += -L$(TOP)/bwdpi_source/asus -lbwdpi
LIBS += -L$(TOP)/bwdpi_source/asus_sql -lbwdpi_sql
LIBS += -L$(TOP)/sqlite/.libs -lsqlite3
LIBS += -lpthread
endif

ifeq ($(RTCONFIG_TRAFFIC_LIMITER),y)
LIBS += -L$(TOP)/traffic_limiter -ltraffic_limiter
LIBS += -L$(TOP)/sqlite/.libs -lsqlite3
endif

ifeq ($(RTCONFIG_GEOIP),y)
CFLAGS += -I$(TOP)/GeoIP-1.6.2/libGeoIP
LIBS += -L$(TOP)/GeoIP-1.6.2/libGeoIP/.libs -lGeoIP
endif

ifeq ($(RTCONFIG_QCA),y)
LIBS += -lpthread -ldl
endif

export CFLAGS
ifeq ($(RTCONFIG_QTN),y)
vpath %.c sysdeps $(TOP)/libqcsapi_client/qcsapi_rpc_common/client $(TOP)/shared/sysdeps/qtn
else
vpath %.c sysdeps
endif

ifeq ($(RTCONFIG_NOTIFICATION_CENTER),y)
CFLAGS  += -I$(TOP)/sqlite
CFLAGS  += -I$(TOP)/nt_center/lib
CFLAGS  += -DASUSWRT_SDK
LIBS += -L$(TOP)/nt_center/lib/ -lnt
LIBS += -L$(TOP)/sqlite/.libs -lsqlite3
LIBS += -lpthread #Depend on sqlite
endif

ifeq ($(RTCONFIG_AIHOME_TUNNEL),y)
CFLAGS  += -I$(TOP)/aaews
endif

ifeq ($(RTCONFIG_LETSENCRYPT),y)
CFLAGS  += -I$(TOP)/libletsencrypt
LIBS += -L$(TOP)/libletsencrypt -lletsencrypt
endif

ifeq ($(RTCONFIG_PERMISSION_MANAGEMENT),y)
CFLAGS  += -I$(TOP)/sqlCipher
CFLAGS  += -I$(TOP)/PMS_DBapis
LIBS += -L$(TOP)/PMS_DBapis -lpms_sql
LIBS += -L $(TOP)/sqlCipher/.libs -lsqlcipher
endif

ifeq ($(RTCONFIG_CFGSYNC),y)
CFLAGS += -I$(TOP)/shared/sysdeps/amas
CFLAGS += -I$(TOP)/cfg_mnt
LIBS += -L$(TOP)/cfg_mnt -lcfgmnt
endif

ifeq ($(RTCONFIG_QSR10G),y)
CFLAGS += -I$(TOP)/libqcsapi_client_10g
LIBS += -L$(TOP)/libqcsapi_client_10g -lqcsapi_client
endif

ifeq ($(RTCONFIG_CONNDIAG),y)
CFLAGS += -I$(TOP)/rc
LIBS += -L$(TOP)/rc -lconn_diag
endif

CFLAGS += -I$(TOP)/libpasswd
LIBS += -L$(TOP)/libpasswd -lpasswd

ifeq ($(RTCONFIG_LANTIQ),y)
LIBS += -L$(TOP)/fapi_wlan_common-05.04.00.131 -lfapiwlancommon -ldl -L$(TOP)/libhelper-1.4.0.2 -lhelper -L$(TOP)/libfapi-0.1 -lfapi -L$(TOP)/wireless_tools/ -liw
endif

ifeq ($(RTCONFIG_LIBASUSLOG),y)
CFLAGS += -I$(TOP)/libasuslog
LIBS += -L$(TOP)/libasuslog -lasuslog
endif

ifeq ($(RTCONFIG_HND_ROUTER_AX_6710),y)
CFLAGS +=-DRTCONFIG_HND_ROUTER_AX_6710
endif
ifeq ($(RTCONFIG_HND_ROUTER_AX_675X),y)
CFLAGS +=-DRTCONFIG_HND_ROUTER_AX_675X
endif
ifeq ($(RTCONFIG_HND_ROUTER_AX_6756),y)
CFLAGS +=-DRTCONFIG_HND_ROUTER_AX_6756
endif

all: httpd #test_apps

#test_apps: apps.c
#	$(CC) -DAPPS $(CFLAGS) $(LIBS) $^ -o $@

httpd: $(OBJS)
	@echo " [httpd] CC $@"
	$(CC) -o $@ $(OBJS) $(LIBS) $(EXTRALDFLAGS)

	$(SIZECHECK)
	$(CPTMP)


install: all
	@echo " [httpd] Installing to $(INSTALLDIR)"
	@install -D httpd $(INSTALLDIR)/usr/sbin/httpd
	$(if $(RTCONFIG_DEBUG),,@$(STRIP) $(INSTALLDIR)/usr/sbin/httpd)
	@cd $(INSTALLDIR)/usr/sbin/; ln -sf httpd httpds
	@chmod 0500 $(INSTALLDIR)/usr/sbin/httpd
	#@install -m 0755 test_apps $(INSTALLDIR)/usr/sbin
	#@$(STRIP) $(INSTALLDIR)/usr/sbin/test_apps

clean:
	rm -f httpd *.o .*.depend test_apps

size: httpd
	mipsel-uclibc-nm --print-size --size-sort httpd

# handle prebuilt object here
ifneq ($(wildcard, ./prebuild/$(BUILD_NAME)),)
ifeq ($(RTCONFIG_HTTPS),y)
pwenc.o:
	@-cp -f ./prebuild/$(BUILD_NAME)/pwenc.o .
endif
web_hook.o:
	@-cp -f ./prebuild/$(BUILD_NAME)/web_hook.o .
endif

%.o: %.c .%.depend
	@echo " [httpd] CC $@"
	@$(CC) $(CFLAGS) -o $@ -c $<

.%.depend: %.c
	@$(CC) $(CFLAGS) -M $< > $@

-include $(OBJS:%.o=.%.depend)

