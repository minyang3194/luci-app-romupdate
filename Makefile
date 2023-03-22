# Copyright (C) 2021 Lenyu

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for AutoBuild Firmware/Romupdate.sh
LUCI_DEPENDS:=+curl +wget +bash
LUCI_PKGARCH:=all
PKG_VERSION:=2
PKG_RELEASE:=20230322

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-romupdate/install
  $(INSTALL_DIR) $(1)/etc/config
  $(INSTALL_CONF) $(PKG_BUILD_DIR)/root/etc/config/romupdate $(1)/etc/config/romupdate
  chmod 755 $(1)/etc/config/romupdate
  chmod 755 $(1)/etc/config/init.d/romupdate
endef

