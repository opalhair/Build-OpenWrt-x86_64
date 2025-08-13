#!/bin/bash
set -e

# 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.9/g' package/base-files/files/bin/config_generate

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
find ./ -type f -name "Makefile" | grep v2ray-geodata | xargs rm -f
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
# --- 替换 MosDNS ---
echo "正在替换为 sbwml v5 版 MosDNS..."

# 1. 精确删除 feeds 中的 mosdns (如果存在)
# 注意：这里需要知道它在 feeds 里的准确路径
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns

# 2. 精确删除 install 后的软链接 (更保险)
rm -rf package/feeds/packages/mosdns
rm -rf package/feeds/luci/luci-app-mosdns

# 3. 克隆新版本到 package 目录
git clone https://github.com/sbwml/luci-app-mosdns.git -b v5 package/mosdns

echo "MosDNS 替换完成。"
chmod +x package/base-files/files/etc/uci-defaults/99-custom-network
