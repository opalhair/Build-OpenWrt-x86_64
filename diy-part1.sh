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

# Passwall
mkdir -p package/passwall
svn co https://github.com/opalhair/packages/trunk/Passwall/luci-app-passwall package/luci-app-passwall
svn co https://github.com/Lienol/openwrt-package/trunk/package/chinadns-ng package/passwall/chinadns-ng
svn co https://github.com/Lienol/openwrt-package/trunk/package/simple-obfs package/passwall/simple-obfs
svn co https://github.com/Lienol/openwrt-package/trunk/package/tcping package/passwall/tcping

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

#更改Passwall显示位置
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/controller/passwall.lua
sed -i "s/VPN/Services/g" package/luci-app-passwall/luasrc/controller/passwall.lua
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/model/cbi/passwall/node_config.lua
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/model/cbi/passwall/node_list.lua
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/model/cbi/passwall/node_subscribe.lua
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/haproxy/status.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/log/log.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/global/tips.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/global/status.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/global/status2.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/node_list/node_list.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/node_list/link_add_node.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/rule/rule_version.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/rule/brook_version.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/rule/v2ray_version.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/rule/kcptun_version.htm
sed -i "s/vpn/services/g" package/luci-app-passwall/luasrc/view/passwall/rule/passwall_version.htm

# OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# AdguardHome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# SmartDNS
mkdir -p package/SmartDNS
git clone https://github.com/pymumu/openwrt-smartdns.git package/SmartDNS/openwrt-smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/SmartDNS/luci-app-smartdns

sed -i "s/option bbr '0'/option bbr '1'/g" package/lean/luci-app-flowoffload/root/etc/config/flowoffload
