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

# Passwall
mkdir -p package/passwall
svn co https://github.com/xiaorouji/openwrt-package/trunk/lienol/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/chinadns-ng package/passwall/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/simple-obfs package/passwall/simple-obfs
svn co https://github.com/xiaorouji/openwrt-package/trunk/package/tcping package/passwall/tcping

#更改Passwall国内的dns
passwall_dns=$(grep -o "option up_china_dns 'default'" package/luci-app-passwall/root/etc/config/passwall | wc -l)
if [[ "$passwall_dns" == "1" ]]; then
	sed -i "s/option up_china_dns 'default'/option up_china_dns '223.5.5.5'/g" package/luci-app-passwall/root/etc/config/passwall
fi

#更改Passwall的dns模式
dns_mode=$(grep -o "option dns_mode 'pdnsd'" package/luci-app-passwall/root/etc/config/passwall | wc -l)
if [[ "$dns_mode" == "1" ]]; then
	sed -i "s/option dns_mode 'pdnsd'/option dns_mode 'chinadns-ng'/g" package/luci-app-passwall/root/etc/config/passwall
fi
# OpenClash
svn co https://github.com/vernesong/OpenClash/branches/master/luci-app-openclash package/luci-app-openclash

# AdguardHome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# SmartDNS
mkdir -p package/SmartDNS
git clone https://github.com/pymumu/openwrt-smartdns.git package/SmartDNS/openwrt-smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/SmartDNS/luci-app-smartdns

sed -i "s/option bbr '0'/option bbr '1'/g" package/lean/luci-app-flowoffload/root/etc/config/flowoffload

# uci-app-dockerman
# mkdir -p package/luci-lib-docker && \
# wget https://raw.githubusercontent.com/lisaac/luci-lib-docker/master/Makefile -O package/luci-lib-docker/Makefile
# mkdir -p package/luci-app-dockerman && \
# wget https://raw.githubusercontent.com/lisaac/luci-app-dockerman/master/Makefile -O package/luci-app-dockerman/Makefile
