#
# Copyright (C) 2019 Apple Computer, Inc.
#
# This is free software, licensed under the Apache Public License v2.
# See /LICENSE for more information.
#
# Some of this is copied from Steven Barth's makefile for mdnsresponder
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dnssd
PKG_RELEASE:=5
PKG_LICENSE:=Apache-2.0
PKG_BUILD_PARALLEL:=0
PKG_INSTALL:=1
PKG_LICENSE:=Apache-v2
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/IETF-Hackathon/mDNSResponder
PKG_MIRROR_HASH:=3b5de721a7452106ef0b4982cb297fc4e4f56c54a3feb96930614675c8778f7b
PKG_SOURCE_DATE:=2019-07-24
PKG_SOURCE_VERSION:=895afe90dd9fc3b21f77e83700b6344f711f19a0
PKG_SOURCE_TAG:=895afe90
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_NAME)-$(PKG_SOURCE_DATE)-$(PKG_SOURCE_TAG)

PKG_MAINTAINER:=Ted Lemon <mellon@fugue.com>

include $(INCLUDE_DIR)/package.mk

define Package/dnssd/Default
  SECTION:=net
  TITLE:=DNSSD
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
endef

define Package/dnssd-proxy
  $(call Package/dnssd/Default)
  TITLE+= Discovery Proxy
  DEPENDS:=libc +libmbedtls +mDNSResponder +mbedtls-write +mbedtls-util
endef

define Package/dns-sd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE+= Discovery Proxy Command Line Tool
  DEPENDS:=libc +libmbedtls
endef

define Package/mDNSResponder
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNSSD Discovery Proxy
  DEPENDS:=libc +libmbedtls
endef

define Package/dnssd/Default/description
   DNSSD (DNS Service Discovery) is a collection of protocols that allow services to
   advertise their existence and their contact details.  Clients can then discover
   services
endef

define Package/dnssd-proxy/description
   $(call Package/dnssd/Default/description)

   DNSSD-Proxy is a reference implementation of the IETF DNS Service Discovery Proxy.
   The Discovery Proxy proxies multicast DNS service from one network to another using
   the DNS protocol.   This allows devices on one link to discover services on another
   link.
endef

define Package/dns-sd/description
   $(call Package/dnssd/Default/description)

   dns-sd is a command line tool for querying the agent when it is running.
endef


define Package/mDNSResponder/description
   $(call Package/dnssd/Default/description)

   mDNSResponder is the Apple implementation of a DNSSD service discovery agent.   It
   can be used to discover services both on the local link using the Multicast DNS
   protocol, and on both local and non-local links using the DNS protocol.  It can
   also be used to publish services on the local link.
endef

# I have no idea why -lc is required, but without it, C library symbols are
# not found:
MAKE_FLAGS += \
	CFLAGS_DEBUG="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -Wno-error" \
        OPEN_SOURCE=1 \
        DEBUG=1 \
	LINKOPTS=-lc \
	LDCONFIG= \
    RESOLVCONF='\"/tmp/resolv.conf.auto\"' \
    CERTWRITE_PROGRAM='\"/usr/bin/cert_write\"' \
    GENKEY_PROGRAM='\"/usr/bin/gen_key\"' \
	ETCBASE="$(PKG_INSTALL_DIR)/etc" \
	INSTBASE="$(PKG_INSTALL_DIR)/usr" \
	NSSINSTPATH="$(PKG_INSTALL_DIR)/lib" \
	MANPATH="$(PKG_INSTALL_DIR)/usr/man" \
	STARTUPSCRIPTDIR="$(PKG_INSTALL_DIR)/etc/init.d" \
	RUNLEVELSCRIPTSDIR="$(PKG_INSTALL_DIR)/etc/rc.d" \
	os=linux-uclibc
MAKE_PATH = mDNSResponder/mDNSPosix

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

define Package/dnssd-proxy/conffiles
/etc/dnssd-proxy.cf
/etc/dnssd-proxy/server.crt
/etc/dnssd-proxy/server.key
endef

define Package/dnssd-proxy/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/dnssd-proxy/
	$(INSTALL_CONF) ./files/dnssd-proxy.cf $(1)/etc/
	$(INSTALL_BIN) ./files/dnssd-proxy.init $(1)/etc/init.d/dnssd-proxy
	$(INSTALL_BIN) ./files/udhcpc.user $(1)/etc/
	$(INSTALL_BIN) ./files/odhcp6c.user $(1)/etc/
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/dnssd-proxy $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
endef

define Package/dns-sd/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/dns-sd $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdns_sd.so.1 $(1)/usr/lib/libdns_sd.so.1.0.0
	(cd $(1)/usr/lib && \
	 ln -s libdns_sd.so.1.0.0 libdns_sd.so.1 && \
	 ln -s libdns_sd.so.1.0.0 libdns_sd.so)
endef

define Package/mDNSResponder/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mDNSResponder.init $(1)/etc/init.d/mDNSResponder
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/mdnsd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
endef

$(eval $(call BuildPackage,dnssd-proxy))
$(eval $(call BuildPackage,dns-sd))
$(eval $(call BuildPackage,mDNSResponder))
