

all dynamic install: conditional_build

#
# Set our CommEngine directory (by splitting the pwd into two words
# at /userspace and taking the first word only).
# Then include the common defines under CommEngine.
# You do not need to modify this part.
#
CURR_DIR := $(shell pwd)
BUILD_DIR:=$(HND_SRC)

include $(BUILD_DIR)/make.common

APP = iproute2-4.19.0

ifneq ($(findstring $(CUR_CHIP_PROFILE),4912),)
CROSS_COMPILE := /opt/toolchains/crosstools-aarch64-gcc-9.2-linux-4.19-glibc-2.30-binutils-2.32/usr/bin/aarch64-buildroot-linux-gnu-
CROSS_COMPILER := $(CROSS_COMPILE)
CONFIGURE := ./configure LD=$(CROSS_COMPILE)ld --host=aarch64-buildroot-linux-gnu
HOSTCONFIG := linux-aarch64 -DL_ENDIAN -march=armv8-a -fomit-frame-pointer -mabi=lp64 -ffixed-r8 -D__ARM_ARCH_8A__
endif

ifeq ($(HND_ROUTER_BE_4916), y)
CFLAGS+= -fcommon
endif

.PHONY: check_untar_patch_configure conditional_build check_versions

ifneq ("$(BUILD_IPROUTE2)$(BUILD_IPV6)$(BRCM_KERNEL_NETQOS)$(BUILD_GPONRG_OMCI_FULL)","")
DO_BUILD_IPROUTE2=y
endif

.PHONY: check_untar_patch_configure conditional_build check_versions

ifneq ($(strip $(DO_BUILD_IPROUTE2)),)
conditional_build: $(APP)

# Depend on tar file
# Use $(APP)/configure to mark tar progress is completed
$(APP)/configure:
	if [ ! -e $(APP) ]; then \
	    mkdir $(APP); cd $(APP); \
	    tar --strip-components=1 -xkf ../$(APP).tar.gz; \
	    cd ..; \
	    touch -c $(APP)/configure; \
	    echo "Applying patches to $(APP)"; \
	    patch -p1 -b -s -d$(APP) < $(APP).patch; \
	fi;
	@echo "$(APP) is untarred"

# Depend on $(APP)/configure so that tar progress should be done only once
$(APP)/Makefile: $(APP)/configure
	cd $(APP); ./configure; cd ../.;
	@echo "$(APP) is configured"

# Depend on $(APP)/Makefile so that configure progress should be done only once
check_config: $(APP)/Makefile

# Depend on check_config so that make progress can continue where it is stopped before
$(APP): check_config
	$(MAKE) -C $(APP) ;
	#install -m 755 $(APP)/ip/ip  $(INSTALL_DIR)/bin/ip
	#install -m 755 $(APP)/tc/tc  $(INSTALL_DIR)/bin/tc
	#$(STRIP) $(INSTALL_DIR)/bin/tc
	#$(STRIP) $(INSTALL_DIR)/bin/ip
	-$(STRIP) $(APP)/ip/ip
	-$(STRIP) $(APP)/tc/tc
	@echo "Done building $(APP)"
	
else
conditional_build: sanity_check
	@echo "skipping $(APP) (not configured)"
endif


# NOTE: make clean from within app does not do a proper job, so wiping out
# entire directory to ensure consistency.
clean:
	rm -f $(INSTALL_DIR)/bin/tc
	rm -f $(INSTALL_DIR)/bin/ip
	$(MAKE) -C $(APP) clean
	#rm -rf $(APP)

# The next line is a hint to our release scripts
# GLOBAL_RELEASE_SCRIPT_CALL_DISTCLEAN
distclean: clean

bcm_dorel_distclean: distclean

shell:
	bash -i
