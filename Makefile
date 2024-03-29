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
ARCH?=armhf
suffix:=$(subst -armhf,,-$(ARCH))

include $(INCLUDE_DIR)/package.mk

define Package/k3s
  TITLE:=K3s Lightweight Kubernetes Engine
  DEPENDS:=+iptables iptables-mod-extra kmod-ipt-extra iptables-mod-extra kmod-br-netfilter ca-certificates
endef

define Package/k3s/description
  Packaged binary builds of official K3S
endef

define Package/k3s/conffiles
/etc/config/k3s
endef

Build/Compile:=:

define Package/k3s/download
	mkdir -p "$@/usr/bin"
	cp -r files/* "$@"
	curl -sfLo "$@/usr/bin/k3s" \
		https://github.com/rancher/k3s/releases/download/v$(VERSION)/k3s${suffix}
	chmod a+x "$@/usr/bin/k3s"
endef

define Package/k3s/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/k3s $(1)/usr/bin/k3s

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/k3s.init $(1)/etc/init.d/k3s

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/k3s.uci $(1)/etc/config/k3s
endef

$(eval $(call BuildPackage,k3s))

.PHONY: all
all: $(OUT)

build-all:
	if [ -n "$$(ls build/)" ]; then echo build/ not empty && exit 1; fi
	for a in $$(cat ARCHS); do \
		for v in $$(cat VERSIONS); do \
			make ARCH=$$a VERSION=$$v; \
		done; \
	done

.PHONY: release
release: build-all
	ghr -t ${GITHUB_TOKEN} -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} \
		-c ${CIRCLE_SHA1} -delete ${PVERSION} build/

$(OUT): $(DIR)/pkg/control.tar.gz $(DIR)/pkg/data.tar.gz $(DIR)/pkg/debian-binary
	tar -C $(DIR)/pkg -czvf "$@" debian-binary data.tar.gz control.tar.gz

$(DIR)/data: $(FILES)
	mkdir -p "$@/usr/bin"
	cp -r files/* "$@"
	curl -sfLo "$@/usr/bin/k3s" \
		https://github.com/k3s-io/k3s/releases/download/v$(VERSION)/k3s${suffix}
	chmod a+x "$@/usr/bin/k3s"

$(DIR)/pkg/data.tar.gz: $(DIR)/data
	tar -C "$<" -czvf "$@" .

$(DIR)/pkg:
	mkdir -p $@

$(DIR)/pkg/debian-binary: $(DIR)/pkg
	echo 2.0 > $@

$(DIR)/pkg/control: $(DIR)/pkg
	echo "$$CONTROL" > "$@"

$(DIR)/pkg/control.tar.gz: $(DIR)/pkg/control
	tar -C $(DIR)/pkg -czvf "$@" control

.PHONY: clean
clean:
	rm -rf build/
