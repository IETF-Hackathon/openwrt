#
# Copyright (C) 2019 Apple Computer, Inc.
#
# This is free software, licensed under the Apache Public License v2.
# See /LICENSE for more information.
#
# Some of this is copied from Steven Barth's makefile for mdnsresponder
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dns-sd
PKG_RELEASE:=5
PKG_LICENSE:=Apache-2.0
PKG_BUILD_DIR:=$(BUILD_DIR)/dns-sd
PKG_BUILD_PARALLEL:=0
PKG_INSTALL:=1

PKG_MAINTAINER:=Ted Lemon <mellon@fugue.com>

include $(INCLUDE_DIR)/package.mk

define Package/dns-sd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=DNSSD Discovery Proxy Command Line Tool
  DEPENDS:=libc +libmbedtls
endef

define Package/dns-sd/description
   mDNSResponder is the Apple implementation of a DNSSD service discovery agent.  
   dns-sd is a command line tool for querying the agent when it is running.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/dns-sd
	(cd ${HOME}/104hackathon/mDNSResponder; tar --exclude objects --exclude build --exclude .git -c -f - .) |(cd $(PKG_BUILD_DIR)/dns-sd; tar xf -)
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
MAKE_PATH = dns-sd/mDNSPosix

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

define Package/dns-sd/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/dns-sd $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libdns_sd.so.1 $(1)/usr/lib/libdns_sd.so.1.0.0
	(cd $(1)/usr/lib && \
	 ln -s libdns_sd.so.1.0.0 libdns_sd.so.1 && \
	 ln -s libdns_sd.so.1.0.0 libdns_sd.so)
endef

$(eval $(call BuildPackage,dns-sd))
