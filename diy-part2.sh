#!/bin/bash
set -e

# ----------------------------
# 0. 适配外部 Go bootstrap 引擎 (支持云端 Setup-Go 与本地环境)
# ----------------------------
if command -v go >/dev/null 2>&1; then
    GOROOT_PATH="${GOROOT_PATH:-$(go env GOROOT)}"
fi

if [ -z "${GOROOT_PATH:-}" ] || [ ! -x "${GOROOT_PATH}/bin/go" ]; then
    echo "ERROR: valid Go bootstrap not found at ${GOROOT_PATH}"
    echo "Install Go first, or export GOROOT_PATH manually."
    exit 1
fi

echo "=== Use external Go bootstrap: ${GOROOT_PATH} ==="
touch .config
sed -i '/CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=/d' .config || true
echo "CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=\"${GOROOT_PATH}\"" >> .config

# ----------------------------
# 1. 替换新版 golang 包树
# ----------------------------
echo "=== Replace golang feed ==="
rm -rf feeds/packages/lang/golang
rm -rf package/feeds/packages/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

# 重新安装 feeds，确保新的 golang 被正确注册
./scripts/feeds install -a -f

# 2. 替换 v5 版 MosDNS
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf package/feeds/packages/mosdns
rm -rf package/feeds/luci/luci-app-mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# 3. 替换 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata
rm -rf package/feeds/packages/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

echo "=== 组件替换完成，清理缓存以重建索引 ==="
# 【核心修复代码】清除编译缓存的“幽灵”，防止 defconfig 产生 syntax error
rm -rf tmp/

echo "=== 开始系统配置 ==="

# 4. 修改默认管理 IP
sed -i 's/192.168.1.1/192.168.3.9/g' package/base-files/files/bin/config_generate

# 5. 写入现代化 DSA 网络配置
# mkdir -p package/base-files/files/etc/uci-defaults/
# cat <<EOF > package/base-files/files/etc/uci-defaults/99-custom-network
# uci set network.br_lan=device
# uci set network.br_lan.name='br-lan'
# uci set network.br_lan.type='bridge'
# uci add_list network.br_lan.ports='eth1'
# uci add_list network.br_lan.ports='eth2'
# uci add_list network.br_lan.ports='eth3'

# uci set network.lan.device='br-lan'
# uci set network.wan.device='eth0'
# uci set network.wan.proto='pppoe'
# uci set network.wan6.device='eth0'

# uci commit network
# EOF
# chmod +x package/base-files/files/etc/uci-defaults/99-custom-network
