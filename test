#!/bin/bash

# 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# 修改网口与拨号设置
sed -i '/exit 0/i \
uci set network.lan.ifname="eth1 eth2 eth3"\
\nuci set network.wan.ifname="eth0"\
\nuci set network.wan.proto=pppoe\
\nuci set network.wan6.ifname="eth0"\
\nuci commit network\
' package/emortal/default-settings/99-default-settings
