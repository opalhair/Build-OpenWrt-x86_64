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





# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default




# SSR-Plus
# svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# OpenClash
src-git openclash https://github.com/vernesong/OpenClash
# svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# svn co https://github.com/openwrt/packages/trunk/net/https-dns-proxy package/openwrt-packages/https-dns-proxy
# sed -i "s/option bbr '0'/option bbr '1'/g" package/lean/luci-app-flowoffload/root/etc/config/flowoffload
# Add a feed source


# sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default

# sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default

# AdguardHome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# 添加 MosDNS 软件源
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
# 替换 Golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
# 替换 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 如需移除不需要的包
rm -rf feeds/packages/utils/mqttled
