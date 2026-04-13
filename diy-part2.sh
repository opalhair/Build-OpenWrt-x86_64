#!/bin/bash
set -e

# 1. 强制覆盖 Golang 环境 (这是解决 ddns-go 报错的核心)
# 删掉 feeds 里的旧版，把新版克隆到本地 package 文件夹，确保优先级最高
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x package/golang

# 2. 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.9/g' package/base-files/files/bin/config_generate

# 3. 现代化网络脚本 (适配 2026 年 DSA 架构，解决 J1900 多网口无法上网)
mkdir -p package/base-files/files/etc/uci-defaults/
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-network
uci set network.br_lan=device
uci set network.br_lan.name='br-lan'
uci set network.br_lan.type='bridge'
uci add_list network.br_lan.ports='eth1'
uci add_list network.br_lan.ports='eth2'
uci add_list network.br_lan.ports='eth3'

uci set network.lan.device='br-lan'
uci set network.wan.device='eth0'
uci set network.wan.proto='pppoe'
uci set network.wan6.device='eth0'

uci commit network
EOF

# 4. 替换 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

chmod +x package/base-files/files/etc/uci-defaults/99-custom-network
