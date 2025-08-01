include ../common.mak
include $(SRCBASE)/.config

LCMODELNAME = $(shell echo $(BUILD_NAME) | tr '[:upper:]' '[:lower:]')
LJPG = $(wildcard dlna/icon_lrg.$(LCMODELNAME).jpg)
SJPG = $(wildcard dlna/icon_sm.$(LCMODELNAME).jpg)
LPNG = $(wildcard dlna/icon_lrg.$(LCMODELNAME).png)
SPNG = $(wildcard dlna/icon_sm.$(LCMODELNAME).png)
ifeq ($(RTCONFIG_BCMARM),y)
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	pkg_type=arm
	DM_VERSION=9.1.0.101
	HTTP_VERSION=9.1.0.97
	OPENSSL_VERSION=9.1.0.2j.v001
else
	pkg_type=arm
	DM_VERSION=3.1.0.101
	HTTP_VERSION=3.1.0.97
	OPENSSL_VERSION=1.0.2j.v001
endif
else ifeq ($(or $(RTCONFIG_QCA),$(RTCONFIG_LANTIQ)),y)
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	pkg_type=arm
	DM_VERSION=9.1.0.101
	HTTP_VERSION=9.1.0.97
	OPENSSL_VERSION=9.1.0.2j.v001
else
	pkg_type=mipsbig
	DM_VERSION=3.1.0.101
	HTTP_VERSION=3.1.0.97
	OPENSSL_VERSION=1.0.2j.v001
endif
else ifeq ($(RTCONFIG_REALTEK),y)
	pkg_type=mipsbig
	DM_VERSION=3.1.0.101
	HTTP_VERSION=3.1.0.97
	OPENSSL_VERSION=1.0.2j.v001
else
	pkg_type=mipsel
	DM_VERSION=3.1.0.101
	HTTP_VERSION=3.1.0.97
	OPENSSL_VERSION=1.0.2j.v001
endif

PKG_LIST := readline wxbase expat zlib libevent ncurses libxml2 pcre spawn-fcgi asuslibcurl

ifeq ($(RTCONFIG_BCMARM),y)
PKG_LIST += libsigc++ libpar2
else ifeq ($(RTCONFIG_QCA),y)
# libuclibc++, libcurl, libsigc++, and libpar2 are not required
PKG_LIST += $(if $(RTCONFIG_APP_PREINSTALLED),libsigc++ libpar2)
else
PKG_LIST += libuclibc++ libsigc++ libpar2
endif

ifeq ($(RTCONFIG_APP_PREINSTALLED),y)
endif
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
PKG_LIST += ncurses-base libiconv

endif

ifeq ($(RTCONFIG_LIVE_UPDATE_RSA),y)
KEY_PATH= $(SRC_ROOT)/../../../key
endif

all:
#	@echo "" >rom/etc/motd
#	@echo "" >>rom/etc/motd
#	@echo "ASUSWRT `cat ../shared/version`" >>rom/etc/motd

clean:
#	rm -f rom/etc/motd

certs/ca-bundle.crt:
	certs/mk-ca-bundle.pl -fu $@

certs: dummy
	certs/mk-ca-bundle.pl -fu certs/ca-bundle.crt

certs-install: certs/ca-bundle.crt
	install -d $(INSTALLDIR)/rom/etc/ssl/certs
	install -m 0644 certs/ca-bundle.crt $(INSTALLDIR)/rom/etc/ssl/certs/ca-certificates.crt
	sed -r '/^\s*(#|$$)/d;/\-BEGIN/{h;d};H;/\-END/{x;/\-BEGIN/p};d' -i $(INSTALLDIR)/rom/etc/ssl/certs/ca-certificates.crt

install:
	mkdir -p $(INSTALLDIR)
	( tar --exclude=.svn --exclude=*.bak -cpf - rom bin ) | ( cd $(INSTALLDIR) && tar -xpf - )
ifeq ($(RTCONFIG_DEBUG),y)
	$(if $(or $(RTCONFIG_SOC_IPQ8064),$(RTCONFIG_SOC_IPQ8074)),install -m 0755 $(if $(filter y,$(MUSL64)),gdb.ipq807x.musl64,gdb.ipq806x) $(INSTALLDIR)/bin/gdb)
	$(if $(RTCONFIG_MT798X),install -m 0755 gdb-10.1-arm64-musl $(INSTALLDIR)/bin/gdb)
endif

	$(MAKE) certs-install
ifeq ($(RTCONFIG_LETSENCRYPT),y)
	install -m 0644 certs/DST_Root_CA_X3.pem $(INSTALLDIR)/rom/etc/ssl/certs/letsencrypt.pem
endif
ifeq ($(RTCONFIG_APP_FILEFLEX),y)
	install -m 0644 ipkg.conf $(INSTALLDIR)/rom/ipkg.conf
endif

ifeq ($(RTAC88U),y)
	install -m 0644 smb.conf $(INSTALLDIR)/rom/smb.conf
endif
ifeq ($(RTCONFIG_APP_PREINSTALLED),y)
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	install -m 0644 optware.asus.$(pkg_type)_new $(INSTALLDIR)/rom/optware.asus
else
	install -m 0644 optware.asus.$(pkg_type) $(INSTALLDIR)/rom/optware.asus
endif
ifeq ($(RTCONFIG_BCMARM),y)
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	install -m 0644 optware.armeabi-ng $(INSTALLDIR)/rom 
else
	install -m 0644 optware.mbwe-bluering $(INSTALLDIR)/rom
endif
else ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	install -m 0644 optware.armeabi-ng $(INSTALLDIR)/rom
else
	install -m 0644 optware.oleg $(INSTALLDIR)/rom
endif
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	install -m 0644 packages_new/asus_base_apps_new_$(pkg_type).tgz $(INSTALLDIR)/rom # Don't need if installing from Internet.	
	-install -m 0644 $(foreach pkg,$(PKG_LIST),packages_new/$(pkg)_*_$(pkg_type).ipk) $(INSTALLDIR)/rom
	-install -m 0644 packages_new/downloadmaster_$(DM_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
	-install -m 0644 packages_new/asusopenssl_$(OPENSSL_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
	-install -m 0644 packages_new/bzip2_*_$(pkg_type).ipk $(INSTALLDIR)/rom
else
	install -m 0644 packages/asus_base_apps_$(pkg_type).tgz $(INSTALLDIR)/rom # Don't need if installing from Internet.
	-install -m 0644 $(foreach pkg,$(PKG_LIST),packages/$(pkg)_*_$(pkg_type).ipk) $(INSTALLDIR)/rom
	-install -m 0644 packages/downloadmaster_$(DM_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
	-install -m 0644 packages/asusopenssl_$(OPENSSL_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
	-install -m 0644 packages/bzip2_*_$(pkg_type).ipk $(INSTALLDIR)/rom
endif
	
ifneq ($(HTTP_VERSION),)
ifeq ($(RTCONFIG_NEW_APP_ARM),y)
	-install -m 0644 packages_new/asuslighttpd_$(HTTP_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
else
	-install -m 0644 packages/asuslighttpd_$(HTTP_VERSION)_$(pkg_type).ipk $(INSTALLDIR)/rom
endif
endif
endif

	mkdir -p $(INSTALLDIR)/usr/sbin
ifeq ($(RTCONFIG_USB),y)
ifneq ($(APP),none)
	install -m 0755 apps_scripts/asusrouter $(INSTALLDIR)/rom/.asusrouter
	install -m 0755 apps_scripts/app_*.sh $(INSTALLDIR)/usr/sbin
	install -m 0755 apps_scripts/check_spectrum.sh $(INSTALLDIR)/usr/sbin
ifeq ($(RTCONFIG_USB_SWAP),y)
	install -m 0755 apps_scripts/usb_swap.sh $(INSTALLDIR)/usr/sbin
endif
else
ifeq ($(RTCONFIG_DISK_MONITOR),y)
	install -m 0755 apps_scripts/app_fsck*.sh $(INSTALLDIR)/usr/sbin
endif
endif
ifeq ($(RTCONFIG_USB_MODEM),y)
	install -m 0644 spn_*.dat $(INSTALLDIR)/rom
	install -m 0755 apps_scripts/find_modem_*.sh $(INSTALLDIR)/usr/sbin
	install -m 0755 apps_scripts/modem_*.sh $(INSTALLDIR)/usr/sbin
ifeq ($(RTCONFIG_INTERNAL_GOBI),y)
	install -m 0755 apps_scripts/gobi_update.sh $(INSTALLDIR)/usr/sbin
endif
endif
endif
	install -m 0755 apps_scripts/3ginfo.sh $(INSTALLDIR)/usr/sbin

ifeq ($(RTCONFIG_DSL),y)
	cp -f webs_scripts/notif_update.sh $(INSTALLDIR)/usr/sbin/notif_update.sh
endif
	#install -m 0755 webs_scripts/*.sh $(INSTALLDIR)/usr/sbin
ifeq ($(RTCONFIG_AUTOLIVEUPDATE_ZIP),y)
	cp -f webs_scripts/zip_webs_upgrade.sh $(INSTALLDIR)/usr/sbin/webs_upgrade.sh
	cp -f webs_scripts/zip_webs_update.sh $(INSTALLDIR)/usr/sbin/webs_update.sh
ifeq ($(RTCONFIG_BWDPI),y)
	cp -f webs_scripts/sig2nd_upgrade.sh $(INSTALLDIR)/usr/sbin/sig_upgrade.sh
	cp -f webs_scripts/sig2nd_update.sh $(INSTALLDIR)/usr/sbin/sig_update.sh
endif
ifeq ($(RTCONFIG_LIVE_UPDATE_RSA),y)
ifneq ("$(wildcard $(KEY_PATH)/public$(LIVE_UPDATE_RSA).pem)","")
	cp -f $(KEY_PATH)/public$(LIVE_UPDATE_RSA).pem $(INSTALLDIR)/usr/sbin/public.pem
else
	cp -f webs_scripts/public.pem $(INSTALLDIR)/usr/sbin/public.pem
endif
	cp -f webs_scripts/swrt.pem $(INSTALLDIR)/usr/sbin/swrt.pem
else
ifeq ($(RTCONFIG_HTTPS),y)
	cp -f webs_scripts/public.pem $(INSTALLDIR)/usr/sbin/public.pem
endif
	cp -f webs_scripts/swrt.pem $(INSTALLDIR)/usr/sbin/swrt.pem
endif
ifeq ($(RTAC68U),y)
ifneq ("$(wildcard $(SRCBASE)/../../buildtools/tmks.bin)","")
	cp -f $(SRCBASE)/../../buildtools/tmks.bin $(INSTALLDIR)/usr/sbin/tmks
endif
endif
else
ifeq ($(RTCONFIG_HTTPS),y)
	cp -f webs_scripts/swrt_webs_upgrade.sh $(INSTALLDIR)/usr/sbin/webs_upgrade.sh
ifeq ($(RTCONFIG_FBWIFI),y)
	cp -f webs_scripts/fbwifi_webs_update.sh $(INSTALLDIR)/usr/sbin/webs_update.sh
else ifeq ($(RTAC68A),y)
	cp -f webs_scripts/force_webs_update.sh $(INSTALLDIR)/usr/sbin/webs_update.sh
else ifeq ($(RTCONFIG_FRS_LIVE_UPDATE),y)
	cp -f webs_scripts/frs_live_update.sh $(INSTALLDIR)/usr/sbin/webs_update.sh
else
	cp -f webs_scripts/ssl_webs_update.sh $(INSTALLDIR)/usr/sbin/webs_update.sh
endif
ifeq ($(RTCONFIG_CFGSYNC),y)
	cp -f webs_scripts/swrt_webs_note.sh $(INSTALLDIR)/usr/sbin/webs_note.sh
endif
else
	cp -f webs_scripts/nozip_webs_upgrade.sh $(INSTALLDIR)/usr/sbin/webs_upgrade.sh
endif

ifeq ($(RTCONFIG_URLFW),y)
	cp -f webs_scripts/urlfw_webs_upgrade.sh $(INSTALLDIR)/usr/sbin/webs_upgrade.sh
endif
ifeq ($(RTCONFIG_SINGLEIMG_B),y)
	cp -f webs_scripts/fwupg_flashing2.sh $(INSTALLDIR)/usr/sbin/fwupg_flashing2.sh
	cp -f webs_scripts/fwupg_create_tmprootfs.sh $(INSTALLDIR)/usr/sbin/fwupg_create_tmprootfs.sh
endif

ifeq ($(RTCONFIG_ROLLBACKFW),y)
	cp -f webs_scripts/ssl_rollback_upgrade.sh $(INSTALLDIR)/usr/sbin/rollback_upgrade.sh
ifeq ($(RTCONFIG_URLFW),y)
	cp -f webs_scripts/urlfw_rollback_upgrade.sh $(INSTALLDIR)/usr/sbin/rollback_upgrade.sh
endif
endif

ifeq ($(RTCONFIG_REVERTFW),y)
	cp -f webs_scripts/ssl_revert_note.sh $(INSTALLDIR)/usr/sbin/revert_note.sh
ifeq ($(RTCONFIG_URLFW),y)
	cp -f webs_scripts/urlfw_revert_upgrade.sh $(INSTALLDIR)/usr/sbin/revert_upgrade.sh
else
	cp -f webs_scripts/ssl_revert_upgrade.sh $(INSTALLDIR)/usr/sbin/revert_upgrade.sh
endif
endif

ifeq ($(RTAC68U),y)
	cp -f webs_scripts/ssl_webs_upgrade_enc.sh $(INSTALLDIR)/usr/sbin/webs_upgrade_enc.sh
	cp -f webs_scripts/ssl_webs_update_enc.sh $(INSTALLDIR)/usr/sbin/webs_update_enc.sh
endif

ifeq ($(or $(RTCONFIG_BWDPI),$(RTCONFIG_BWDPI_DEP)),y)
	cp -f webs_scripts/sig2nd_upgrade.sh $(INSTALLDIR)/usr/sbin/sig_upgrade.sh
	cp -f webs_scripts/sig2nd_update.sh $(INSTALLDIR)/usr/sbin/sig_update.sh
endif
ifeq ($(RTCONFIG_LIVE_UPDATE_RSA),y)
ifneq ("$(wildcard $(KEY_PATH)/public$(LIVE_UPDATE_RSA).pem)","")
	cp -f $(KEY_PATH)/public$(LIVE_UPDATE_RSA).pem $(INSTALLDIR)/usr/sbin/public.pem
else
	cp -f webs_scripts/public.pem $(INSTALLDIR)/usr/sbin/public.pem
endif
	cp -f webs_scripts/swrt.pem $(INSTALLDIR)/usr/sbin/swrt.pem
else
ifeq ($(RTCONFIG_HTTPS),y)
	cp -f webs_scripts/public.pem $(INSTALLDIR)/usr/sbin/public.pem
endif
	cp -f webs_scripts/swrt.pem $(INSTALLDIR)/usr/sbin/swrt.pem
endif
ifeq ($(RTAC68U),y)
ifneq ("$(wildcard $(SRCBASE)/../../buildtools/tmks.bin)","")
	cp -f $(SRCBASE)/../../buildtools/tmks.bin $(INSTALLDIR)/usr/sbin/tmks
endif
endif
endif

	# remove comments, compress whitespace
	sed 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' < rom/etc/services > $(INSTALLDIR)/rom/etc/services
	sed 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' < rom/etc/protocols > $(INSTALLDIR)/rom/etc/protocols
	sed 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' < rom/etc/ethertypes > $(INSTALLDIR)/rom/etc/ethertypes

ifeq ($(HND_ROUTER),y)
	sed 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' < rom/etc/nsswitch.conf > $(INSTALLDIR)/rom/etc/nsswitch.conf
else
	rm -f $(INSTALLDIR)/rom/etc/nsswitch.conf
endif

ifeq ($(RTCONFIG_HTTPS),y)
	sed 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' < rom/etc/openssl.cnf > $(INSTALLDIR)/rom/etc/openssl.cnf
else
	rm -f $(INSTALLDIR)/rom/etc/openssl.cnf
endif

ifeq ($(RTCONFIG_RALINK_RT3883),y)
	mkdir -p $(INSTALLDIR)/rom/wlan
	cp -rf wlan/RT3092_PCIe_LNA_2T2R_ALC_V1_2.bin $(INSTALLDIR)/rom/wlan/
	cp -rf wlan/RT3662_AP_2T2R_V0_0.bin $(INSTALLDIR)/rom/wlan/
endif

ifeq ($(RTAC68U),y)
	mkdir -p $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_tmo.bin $(INSTALLDIR)/rom/cfe/
	cp -rf cfe/cfe_1.0.2.0.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_1.0.2.0_esmt.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_ac66u_b1_1.1.2.0.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_rt-ac68u_5636_c0_1.3.0.7.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_rt-ac68u_v2_5003_1.0.2.9.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/mtd-write $(INSTALLDIR)/rom/cfe/
endif

ifeq ($(RTAC3200),y)
	mkdir -p $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_rt-ac3200_1.0.1.7_128k.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/cfe_rt-ac3200_2.0.0.4_128k.bin $(INSTALLDIR)/rom/cfe
	cp -rf cfe/mtd-write $(INSTALLDIR)/rom/cfe/
endif

ifeq ($(RTCONFIG_MEDIA_SERVER),y)
	mkdir -p $(INSTALLDIR)/rom/dlna
ifeq ($(BUILD_NAME), RT-AC68U)
	cp -rf dlna/icon_sm.rt-ac66u_v2.jpg $(INSTALLDIR)/rom/dlna/icon_alt_sm.jpg
	cp -rf dlna/icon_sm.rt-ac66u_v2.png $(INSTALLDIR)/rom/dlna/icon_alt_sm.png
	cp -rf dlna/icon_lrg.rt-ac66u_v2.jpg $(INSTALLDIR)/rom/dlna/icon_alt_lrg.jpg
	cp -rf dlna/icon_lrg.rt-ac66u_v2.png $(INSTALLDIR)/rom/dlna/icon_alt_lrg.png
	cp -rf dlna/icon_sm.rp-ac1900.jpg $(INSTALLDIR)/rom/dlna/icon_alt2_sm.jpg
	cp -rf dlna/icon_sm.rp-ac1900.png $(INSTALLDIR)/rom/dlna/icon_alt2_sm.png
	cp -rf dlna/icon_lrg.rp-ac1900.jpg $(INSTALLDIR)/rom/dlna/icon_alt2_lrg.jpg
	cp -rf dlna/icon_lrg.rp-ac1900.png $(INSTALLDIR)/rom/dlna/icon_alt2_lrg.png
endif
ifeq ($(BUILD_NAME), RT-AX82U)
	install -m 0755 dlna/icon_sm.rt-ax82u_gd.jpg $(INSTALLDIR)/rom/dlna/icon_gd_sm.jpg
	install -m 0755 dlna/icon_sm.rt-ax82u_gd.png $(INSTALLDIR)/rom/dlna/icon_gd_sm.png
	install -m 0755 dlna/icon_lrg.rt-ax82u_gd.jpg $(INSTALLDIR)/rom/dlna/icon_gd_lrg.jpg
	install -m 0755 dlna/icon_lrg.rt-ax82u_gd.png $(INSTALLDIR)/rom/dlna/icon_gd_lrg.png
endif
ifeq ($(BUILD_NAME), RT-AX82U_V2)
	install -m 0755 dlna/icon_sm.rt-ax82u_v2_gd.jpg $(INSTALLDIR)/rom/dlna/icon_gd_sm.jpg
	install -m 0755 dlna/icon_sm.rt-ax82u_v2_gd.png $(INSTALLDIR)/rom/dlna/icon_gd_sm.png
	install -m 0755 dlna/icon_lrg.rt-ax82u_v2_gd.jpg $(INSTALLDIR)/rom/dlna/icon_gd_lrg.jpg
	install -m 0755 dlna/icon_lrg.rt-ax82u_v2_gd.png $(INSTALLDIR)/rom/dlna/icon_gd_lrg.png
endif
ifeq ($(BUILD_NAME), GTAX6000)
	install -m 0755 dlna/icon_sm.gt-ax6000_eva.jpg $(INSTALLDIR)/rom/dlna/icon_eva_sm.jpg
	install -m 0755 dlna/icon_sm.gt-ax6000_eva.png $(INSTALLDIR)/rom/dlna/icon_eva_sm.png
	install -m 0755 dlna/icon_lrg.gt-ax6000_eva.jpg $(INSTALLDIR)/rom/dlna/icon_eva_lrg.jpg
	install -m 0755 dlna/icon_lrg.gt-ax6000_eva.png $(INSTALLDIR)/rom/dlna/icon_eva_lrg.png
endif
ifeq ($(and $(LJPG),$(SJPG),$(LPNG),$(SPNG)),)
	$(warning Add media server icon for $(BUILD_NAME) !!!!!!!!!!!!)
else
	$(foreach f, icon_sm icon_lrg, install -D dlna/$(f).$(LCMODELNAME).jpg $(INSTALLDIR)/rom/dlna/$(f).jpg; \
		install -D dlna/$(f).$(LCMODELNAME).png $(INSTALLDIR)/rom/dlna/$(f).png;)
endif
endif

ifeq ($(RTCONFIG_GETREALIP),y)
	mkdir -p $(INSTALLDIR)/usr/sbin
	install -m 0755 apps_scripts/getrealip.sh $(INSTALLDIR)/usr/sbin/getrealip.sh
endif

ifneq ($(RTCONFIG_INADYN),y)
	install -m 0755 webs_scripts/GoogleDNS_Update.sh $(INSTALLDIR)/usr/sbin
endif
ifeq ($(RTCONFIG_HND_ROUTER_AX),y)
ifneq ($(BUILD_NAME), RP-AX56)
	install -m 0755 apps_scripts/runin/$(BUILD_NAME)/stress_pkteng.sh $(INSTALLDIR)/usr/sbin
endif
endif

ifeq ($(HND_ROUTER),y)
	mkdir -p $(INSTALL_DIR)/rom/rom/usr/share/zoneinfo
	cp -rf zoneinfo/* $(INSTALL_DIR)/rom/rom/usr/share/zoneinfo/
endif

ifeq ($(HND_ROUTER),y)
	mv -f $(INSTALLDIR)/rom/etc/profile.hnd $(INSTALLDIR)/rom/etc/profile
else
	rm -f $(INSTALLDIR)/rom/etc/profile.hnd
endif

ifeq ($(RTCONFIG_TPVPN),y)
	mkdir -p $(INSTALLDIR)/rom/vpn
	install -m 0644 vpn/HMA_TCP.JSON $(INSTALLDIR)/rom/vpn/HMA_TCP.JSON
	install -m 0644 vpn/HMA_UDP.JSON $(INSTALLDIR)/rom/vpn/HMA_UDP.JSON
endif

ifeq ($(RTCONFIG_HND_ROUTER_AX_6756), y)
	install -m 0755 apps_scripts/brcm_cled.sh $(INSTALLDIR)/usr/sbin
endif

ifeq ($(RTCONFIG_FSMD),y)
	sed '/#/d' ../.config > $(INSTALLDIR)/rom/rtconfig
endif

ifeq ($(RTCONFIG_BCM_MFG), y)
ifeq ($(BUILD_NAME), GT10)
	mkdir -p $(INSTALLDIR)/rom/dhd/6715b0_mfg
	install -m 0644 dhd/6715b0_mfg/GT10/rtecdc_17.10.188.6401.bin $(INSTALLDIR)/rom/dhd/6715b0_mfg/rtecdc.bin
endif
ifeq ($(BUILD_NAME), RT-AXE7800)
	mkdir -p $(INSTALLDIR)/rom/dhd/6715b0_mfg
	install -m 0644 dhd/6715b0_mfg/RT-AXE7800/rtecdc_17.10.188.6401.bin $(INSTALLDIR)/rom/dhd/6715b0_mfg/rtecdc.bin
endif
ifeq ($(BUILD_NAME),$(filter $(BUILD_NAME),RT-AX82U_V2 TUF-AX5400_V2 XD6_V2 RT-AX5400))
	mkdir -p $(INSTALLDIR)/rom/dhd/6715b0_mfg
	install -m 0644 dhd/6715b0_mfg/RT-AX82U_V2/rtecdc_17.10.188.6401.bin $(INSTALLDIR)/rom/dhd/6715b0_mfg/rtecdc.bin
endif
endif

ifeq ($(RTAX86U), y)
	install -m 0755 9873w_b0-b4.bin $(INSTALLDIR)/rom
endif

ifeq ($(BRCM_CHIP),63178)
	cp -rf rom/etc/adsl1 $(INSTALLDIR)/rom/etc
endif

ifeq ($(BUILD_NAME),$(filter $(BUILD_NAME),GT10 RT-AX9000))
	install -m 0755 apps_scripts/$(BUILD_NAME)/ingress_filter_config.sh $(INSTALLDIR)/usr/sbin
	install -m 0755 apps_scripts/$(BUILD_NAME)/ingress_filter_config_bridging.sh $(INSTALLDIR)/usr/sbin
endif

ifeq ($(RTCONFIG_BCMARM),y)
	install -m 0755 apps_scripts/brcmsysinfo.sh $(INSTALLDIR)/usr/sbin
endif

.PHONY: dummy

