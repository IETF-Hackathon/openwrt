#
# Copyright (C) 2012-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.

include $(TOPDIR)/rules.mk

PKG_NAME:=homenet
PKG_SOURCE_VERSION:=606d7e904603ad8792ac1a7ba825618df97b5a4e
PKG_VERSION:=2016-06-28-$(PKG_SOURCE_VERSION)
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/sbyx/hnetd.git
PKG_MAINTAINER:=Steven Barth <cyrus@openwrt.org>
PKG_LICENSE:=GPL-2.0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# Spammy debug builds for now
CMAKE_OPTIONS += -DL_LEVEL=7

# OpenWRT target
CMAKE_OPTIONS += -DBACKEND=openwrt

ifeq ($(BUILD_VARIANT),openssl)
CMAKE_OPTIONS += -DDTLS_OPENSSL=1
endif

define Package/homenet/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=HNCP Homenet daemon - $(2)
  URL:=https://github.com/sbyx/homenet
  DEPENDS:=+odhcpd +odhcp6c +netifd $(3)
  DEPENDS+=@IPV6
  VARIANT:=$1
endef

Package/homenet-nossl=$(call Package/homenet/Default,nossl,no authentication)
Package/homenet-openssl=$(call Package/homenet/Default,openssl,authentication via OpenSSL,+libopenssl)

define Package/homenet-full
  SECTION:=net
  CATEGORY:=Network
  TITLE:=HNCP Homenet metapackage
  URL:=https://github.com/sbyx/hnetd
  DEPENDS:=+homenet-nossl +luci-app-homenet +ip
  # Routing
  DEPENDS+=+babeld
  # Distributed PCP support
  DEPENDS+=+miniupnpd +minimalist-pcproxy
endef

define Package/homenet-full-secure
  SECTION:=net
  CATEGORY:=Network
  TITLE:=HNCP Homenet metapackage (w/ SSL)
  URL:=https://github.com/sbyx/hnetd
  DEPENDS:=+homenet-openssl +luci-app-homenet +ip
  # Routing
  DEPENDS+=+babeld
  # Distributed PCP support
  DEPENDS+=+miniupnpd +minimalist-pcproxy
endef

define Package/homenet-full-l2tp
  SECTION:=net
  CATEGORY:=Network
  TITLE:=HNCP Homenet metapackage (w/ L2TP)
  URL:=https://github.com/sbyx/hnetd
  DEPENDS:=+homenet-nossl +luci-app-homenet +ip-full +kmod-l2tp-eth
  # Routing
  DEPENDS+=+babeld
  # Distributed PCP support
  DEPENDS+=+miniupnpd +minimalist-pcproxy
endef

define Package/luci-app-homenet
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=HNCP Homenet configuration and visualization
#  DEPENDS:=+homenet
# TBD - how to express dependency on 'some' homenet?
endef

define Package/homenet-$(BUILD_VARIANT)/description
This package provides a daemon which implementats distributed prefix assignment
and service discovery for a home network consisting of multiple routers
connected to multiple service providers. It provides a netifd protocol "homenet"
for use in /etc/config/network.
endef

define Package/homenet-$(BUILD_VARIANT)/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/hnetd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/openwrt/hnet.sh $(1)/lib/netifd/proto
	ln -s homenet $(1)/usr/sbin/hnetd-ifresolve
	ln -s homenet $(1)/usr/sbin/hnetd-trust
	ln -s homenet $(1)/usr/sbin/hnetd-dump
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/hnetd.init $(1)/etc/init.d/hnetd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/hnet.config $(1)/etc/config/hnet
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/ohp.script $(1)/usr/sbin/hnetd-ohp-script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/ddz.script $(1)/usr/sbin/hnetd-ddz-script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/pcp.script $(1)/usr/sbin/hnetd-pcp-script
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/hnetd-routing $(1)/usr/sbin/hnetd-routing
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/hnetd.defaults $(1)/etc/uci-defaults/x-hnetd.defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/multicast.script $(1)/usr/sbin/hnetd-multicast
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/openwrt/autowifi.script $(1)/usr/sbin/autowifi
endef

define Package/homenet-full/install
	true
endef

define Package/homenet-full-secure/install
	true
endef

define Package/homenet-full-l2tp/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/generic/tunnel.script $(1)/usr/sbin/hnetd-tunnel
endef

define Package/luci-app-homenet/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/www
	$(CP) -R $(PKG_BUILD_DIR)/openwrt/luci/luasrc/* $(1)/usr/lib/lua/luci/
	$(CP) -R $(PKG_BUILD_DIR)/openwrt/luci/htdocs/* $(1)/www/
endef

define Package/homenet-$(BUILD_VARIANT)/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	(. /etc/uci-defaults/x-hnetd.defaults) && rm -f /etc/uci-defaults/x-hnetd.defaults
	[ -x /etc/init.d/dnsmasq ] && /etc/init.d/dnsmasq restart
	/etc/init.d/hnetd enable
	/etc/init.d/hnetd start
}
endef

$(eval $(call BuildPackage,homenet-nossl))
$(eval $(call BuildPackage,homenet-openssl))
$(eval $(call BuildPackage,homenet-full))
$(eval $(call BuildPackage,homenet-full-secure))
$(eval $(call BuildPackage,homenet-full-l2tp))
$(eval $(call BuildPackage,luci-app-homenet))
