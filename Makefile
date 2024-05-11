#
## Copyright (C) 2024 AreYouLoco?
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=k3s
PKG_VERSION:=v1.30.0+k3s1
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Don't count me for sure
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_URL:=https://github.com/k3s-io/k3s/
PKG_ARCH:=arm_cortex-a9_vfpv3-d16
ARCH:=armhf

include $(INCLUDE_DIR)/package.mk

define Package/k3s
  TITLE:=K3s Lightweight Kubernetes Engine
  DEPENDS:=+iptables iptables-mod-extra kmod-ipt-extra iptables-mod-extra kmod-br-netfilter ca-certificates
endef

define Package/k3s/description
  Packaged binary builds of official K3S
endef

define Download/binaries
  FILE:=k3s-armhf
  URL:=https://github.com/k3s-io/k3s/releases/download/v1.30.0%2Bk3s1
  HASH:=73e830f7c3e9bc774fe3fcfaaba82ce6ea04498592d26a8aa1a58e75d9837166
endef

define Build/Prepare
	mkdir -p $(DL_DIR)
	echo $(DL_DIR)
	cd $(DL_DIR)
	pwd
	$(call Download,binaries)
	ls $(DL_DIR)
endef

define Build/Compile
	mkdir -p $(PKG_BUILD_DIR)
	ls $(PKG_BUILD_DIR)
endef

define Package/k3s/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/k3s-wrapper $(1)/usr/bin/k3s-wrapper

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/k3s-armhf $(1)/usr/bin/k3s

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/k3s $(1)/etc/init.d/k3s
endef

$(eval $(call BuildPackage,k3s))
