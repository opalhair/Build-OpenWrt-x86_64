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



#修改版本内核（下面两行代码前面有#为源码默认最新5.4内核,没#为4.19内核,默认修改X86的，其他机型L大那里target/linux查看，对应修改下面的路径就好）
# sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=4.19/g' ./target/linux/x86/Makefile  #修改内核版本
# sed -i 's/KERNEL_TESTING_PATCHVER:=5.4/KERNEL_TESTING_PATCHVER:=4.19/g' ./target/linux/x86/Makefile  #修改内核版本

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


# SSR-Plus
# svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# passwall
# sed -i '$a src-git passwall https://github.com/xiaorouji/openwrt-passwall2.git' feeds.conf.default
# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
# sed -i '$a src-git small https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
# svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core

# sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default

# sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default

# AdguardHome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# uci-app-dockerman
# git clone https://github.com/lisaac/luci-app-dockerman.git package/openwrt-packages/luci-app-dockerman

# rClone
# rm -rf package/lean/luci-app-rclone
# rm -rf package/lean/rclone-webui-react
# rm -rf package/lean/rclone
# mkdir -p package/Rclone-OpenWrt
# svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/luci-app-rclone package/Rclone-OpenWrt/luci-app-rclone
# svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone-webui-react package/Rclone-OpenWrt/rclone-webui-react
# svn co https://github.com/ElonH/Rclone-OpenWrt/trunk/rclone package/Rclone-OpenWrt/rclone
# OpenClash
src-git openclash https://github.com/vernesong/OpenClash
# svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# svn co https://github.com/openwrt/packages/trunk/net/https-dns-proxy package/openwrt-packages/https-dns-proxy
# sed -i "s/option bbr '0'/option bbr '1'/g" package/lean/luci-app-flowoffload/root/etc/config/flowoffload
# Add a feed source
# 添加 MosDNS 软件源
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

