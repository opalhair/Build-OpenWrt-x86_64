#!/bin/bash
set -e

# 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.9/g' package/base-files/files/bin/config_generate

# 创建 uci-defaults 目录
mkdir -p package/base-files/files/etc/uci-defaults/

# 写入现代化网络脚本 (适配 DSA 和 nftables 架构)
cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-network
# 清理可能残留的旧语法
uci -q delete network.lan.ifname
uci -q delete network.wan.ifname
uci -q delete network.wan6.ifname

# 定义网桥设备包含的物理网口
uci set network.br_lan=device
uci set network.br_lan.name='br-lan'
uci set network.br_lan.type='bridge'
uci add_list network.br_lan.ports='eth1'
uci add_list network.br_lan.ports='eth2'
uci add_list network.br_lan.ports='eth3'

# 绑定接口
uci set network.lan.device='br-lan'
uci set network.wan.device='eth0'
uci set network.wan.proto='pppoe'
uci set network.wan6.device='eth0'

uci commit network
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-custom-network

# 替换 golang 包（注意：若未来编译在 Go 环节报错，请关注 sbwml 仓库的最新分支号）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 替换 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
find ./ -type f -name "Makefile" | grep v2ray-geodata | xargs rm -f
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 替换 MosDNS (精确清理并克隆)
echo "正在替换为 sbwml v5 版 MosDNS..."
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf package/feeds/packages/mosdns
rm -rf package/feeds/luci/luci-app-mosdns
git clone https://github.com/sbwml/luci-app-mosdns.git -b v5 package/mosdns
echo "MosDNS 替换完成。"
