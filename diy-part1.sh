#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=============================================================

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

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

# advancedsetting (方便上海电信IPTV用户在dnsmasq界面中输入数据，SSH 路由器也有同样效果。）
svn co https://github.com/opalhair/openwrt-packages/trunk/luci-app-advancedsetting package/luci-app-advancedsetting

# koolproxyR
# git clone https://github.com/tzxiaozhen88/koolproxyR package/koolproxyR

# rClone
rm -rf package/lean/luci-app-rclone
rm -rf package/lean/rclone-webui-react
rm -rf package/lean/rclone
mkdir -p package/Rclone-OpenWrt
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/luci-app-rclone package/Rclone-OpenWrt/luci-app-rclone
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone-webui-react package/Rclone-OpenWrt/rclone-webui-react
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone package/Rclone-OpenWrt/rclone

# clash
# git clone https://github.com/frainzy1477/luci-app-clash package/luci-app-clash

# OpenClash
svn co https://github.com/vernesong/OpenClash/branches/master/luci-app-openclash package/luci-app-openclash

# AdguardHome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# SmartDNS
mkdir -p package/SmartDNS
git clone https://github.com/pymumu/openwrt-smartdns.git package/SmartDNS/openwrt-smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/SmartDNS/luci-app-smartdns

# sed -i "s/option bbr '0'/option bbr '1'/g" package/lean/luci-app-flowoffload/root/etc/config/flowoffload

# uci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/openwrt-packages/luci-app-dockerman
