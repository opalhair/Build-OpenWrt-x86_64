#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

rm -rf feeds/packages/net/https-dns-proxy

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# advancedsetting (方便上海电信IPTV用户在dnsmasq界面中输入数据，SSH 路由器也有同样效果。）
svn co https://github.com/opalhair/openwrt-packages/trunk/luci-app-advancedsetting package/luci-app-advancedsetting

# SSR-Plus
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

#passwall
sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
svn co https://github.com/xiaorouji/openwrt-package/trunk/lienol/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/brook package/brook
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/trojan-plus package/trojan-plus
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/syncthing package/syncthing

# AdguardHome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# uci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/openwrt-packages/luci-app-dockerman

# rClone
rm -rf package/lean/luci-app-rclone
rm -rf package/lean/rclone-webui-react
rm -rf package/lean/rclone
mkdir -p package/Rclone-OpenWrt
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/luci-app-rclone package/Rclone-OpenWrt/luci-app-rclone
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone-webui-react package/Rclone-OpenWrt/rclone-webui-react
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone package/Rclone-OpenWrt/rclone

svn co https://github.com/openwrt/packages/trunk/net/https-dns-proxy package/openwrt-packages/https-dns-proxy
