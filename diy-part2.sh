#!/bin/bash
# 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# 创建自定义 uci-defaults 脚本，设置网口和拨号
mkdir -p package/base-files/files/etc/uci-defaults/
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-network
uci set network.lan.ifname="eth1 eth2 eth3"
uci set network.wan.ifname="eth0"
uci set network.wan.proto=pppoe
uci set network.wan6.ifname="eth0"
uci commit network
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-custom-network

