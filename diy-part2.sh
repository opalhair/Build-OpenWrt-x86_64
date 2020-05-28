#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# Modify default IP
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# Modify Default Password
# sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$HpIRxWei$9.QF7hD6aYMMluUbzoTYL/:0:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

echo 'Custom settings'
sed -i '$i uci set network.lan.ifname="eth1 eth2 eth3"' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.ifname="eth0"' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan.proto=pppoe' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci set network.wan6.ifname="eth0"' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit network' package/lean/default-settings/files/zzz-default-settings
