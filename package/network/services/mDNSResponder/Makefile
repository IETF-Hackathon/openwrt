#
# Copyright (C) 2019 Apple Computer, Inc.
#
# This is free software, licensed under the Apache Public License v2.
# See /LICENSE for more information.
#
# Some of this is copied from Steven Barth's makefile for mdnsresponder
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mDNSResponder
PKG_RELEASE:=5
PKG_LICENSE:=Apache-2.0
PKG_BUILD_DIR:=$(BUILD_DIR)/mDNSResponder
PKG_BUILD_PARALLEL:=0
PKG_INSTALL:=1

PKG_MAINTAINER:=Ted Lemon <mellon@fugue.com>

include $(INCLUDE_DIR)/package.mk

define Package/mDNSResponder
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNSSD Discovery Proxy
  DEPENDS:=libc +libmbedtls
endef

define Package/mDNSResponder/description
   mDNSResponder is the Apple implementation of a DNSSD service discovery agent.   It
   can be used to discover services both on the local link using the Multicast DNS
   protocol, and on both local and non-local links using the DNS protocol.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/mDNSResponder
	(cd ${HOME}/104hackathon/mDNSResponder; tar --exclude objects --exclude build --exclude .git -c -f - .) |(cd $(PKG_BUILD_DIR)/mDNSResponder; tar xf -)
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

define Package/mDNSResponder/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mDNSResponder.init $(1)/etc/init.d/mDNSResponder
	$(CP) $(PKG_INSTALL_DIR)/usr/sbin/mdnsd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
endef

$(eval $(call BuildPackage,mDNSResponder))
