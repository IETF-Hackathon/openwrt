#
# Copyright (C) 2019 Apple Computer, Inc.
#
# This is free software, licensed under the Apache Public License v2.
# See /LICENSE for more information.
#
# Some of this is copied from Steven Barth's makefile for mdnsresponder
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dnssd-relay
PKG_RELEASE:=5
PKG_LICENSE:=Apache-2.0
PKG_BUILD_DIR:=$(BUILD_DIR)/dnssd-proxy
PKG_BUILD_PARALLEL:=0
PKG_INSTALL:=1

PKG_MAINTAINER:=Ted Lemon <mellon@fugue.com>

include $(INCLUDE_DIR)/package.mk

define Package/dnssd-proxy
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNSSD Discovery Proxy
  DEPENDS:=libc +libmbedtls +mDNSResponder
endef

define Package/dnssd-proxy/description
   DNSSD-Proxy is a reference implementation of the IETF DNS Service Discovery Proxy.
   The Discovery Proxy proxies multicast DNS service from one network to another using
   the DNS protocol.   This allows devices on one link to discover services on another
   link.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/mDNSResponder
	(cd /Users/elemon/104hackathon/mDNSResponder; tar --exclude objects --exclude build --exclude .git --exclude .depfile\* -c -f - .) |(cd $(PKG_BUILD_DIR)/mDNSResponder; tar xf -)
endef

# I have no idea why -lc is required, but without it, C library symbols are
# not found:
MAKE_FLAGS += \
	CFLAGS_DEBUG="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Wno-error" \
        OPEN_SOURCE=1 \
        DEBUG=1 \
	LINKOPTS=-lc \
	LDCONFIG= \
	ETCBASE="$(PKG_INSTALL_DIR)/etc" \
	INSTBASE="$(PKG_INSTALL_DIR)/usr" \
	NSSINSTPATH="$(PKG_INSTALL_DIR)/lib" \
	MANPATH="$(PKG_INSTALL_DIR)/usr/man" \
	STARTUPSCRIPTDIR="$(PKG_INSTALL_DIR)/etc/init.d" \
	RUNLEVELSCRIPTSDIR="$(PKG_INSTALL_DIR)/etc/rc.d" \
	os=linux-uclibc
MAKE_PATH = mDNSResponder/ServiceRegistration

TARGET_CFLAGS += -ggdb3 -g -O0

define Build/Compile
	$(call Build/Compile/Default)
	# XXX: mDNSResponder's "make install" does not seem to create:
	mkdir -p $(PKG_INSTALL_DIR)/lib/
	mkdir -p $(PKG_INSTALL_DIR)/usr/bin/
	mkdir -p $(PKG_INSTALL_DIR)/usr/sbin/
	mkdir -p $(PKG_INSTALL_DIR)/usr/lib/
	mkdir -p $(PKG_INSTALL_DIR)/usr/man/man5/
	mkdir -p $(PKG_INSTALL_DIR)/usr/man/man8/
	mkdir -p $(PKG_INSTALL_DIR)/usr/include/
	mkdir -p $(PKG_INSTALL_DIR)/etc/
	mkdir -p $(PKG_INSTALL_DIR)/etc/init.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc2.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc3.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc4.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc5.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc0.d/
	mkdir -p $(PKG_INSTALL_DIR)/etc/rc.d/rc6.d/
endef

define Package/dnssd-proxy/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/dnssd-proxy/
	$(INSTALL_CONF) ./files/dnssd-proxy.cf $(1)/etc/
	$(INSTALL_BIN) ./files/dnssd-proxy.init $(1)/etc/init.d/dnssd-proxy
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/dnssd-proxy $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
endef

$(eval $(call BuildPackage,dnssd-proxy))
