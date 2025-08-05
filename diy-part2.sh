#!/bin/bash
set -e

# 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

# 创建 uci-defaults 目录
mkdir -p package/base-files/files/etc/uci-defaults/

# 写入自定义网络脚本
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-network
uci set network.lan.ifname="eth1 eth2 eth3"
uci set network.wan.ifname="eth0"
uci set network.wan.proto=pppoe
uci set network.wan6.ifname="eth0"
uci commit network
EOF
# 替换 golang 包（适配新版依赖）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 替换 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
chmod +x package/base-files/files/etc/uci-defaults/99-custom-network
