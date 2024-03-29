#
## Copyright (C) 2024 AreYouLoco?
#
## This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=k3s
PKG_VERSION?=$(shell head -1 VERSIONS)
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Don't count me for sure
PKG_LICENSE:=GPL-2.0-only
PKG_LICENSE_FILES:=LICENSE.md
PKG_URL:=https://github.com/k3s-io/k3s/
PKG_ARCH:=arm_cortex-a9_vfpv3-d16
PKG_SOURCE:=$(PKG_NAME)-$(ARCH)
PKG_SOURCE_URL:=https://github.com/k3s-io/k3s/releases/download/v$(PKG_VERSION)/
PKG_CAT:=cat
ARCH:=armhf

include $(INCLUDE_DIR)/package.mk

define Package/k3s
  TITLE:=K3s Lightweight Kubernetes Engine
  DEPENDS:=+iptables iptables-mod-extra kmod-ipt-extra iptables-mod-extra kmod-br-netfilter ca-certificates
endef

define Package/k3s/description
  Packaged binary builds of official K3S
endef

Build/Compile:=:

define Package/k3s/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/k3s-wrapper $(1)/usr/bin/k3s-wrapper

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/k3s $(1)/etc/init.d/k3s
endef

$(eval $(call BuildPackage,k3s))
