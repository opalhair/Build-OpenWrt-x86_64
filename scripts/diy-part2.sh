#!/bin/bash
set -euo pipefail

echo "=== diy-part2: start ==="

# 基本目录检查
if [ ! -d "./scripts" ] || [ ! -d "./package" ]; then
    echo "ERROR: Please run this script from ImmortalWrt source root"
    exit 1
fi

# ----------------------------
# 环境变量（可由调用方覆盖）
# ----------------------------
DEFAULT_IP="${DEFAULT_IP:-192.168.3.9}"
BUILD_TARGET="${BUILD_TARGET:-UTM}"
WAN_PROTO="${WAN_PROTO:-pppoe}"
IPTV_PROFILE="${IPTV_PROFILE:-NONE}"
REPLACE_GOLANG="${REPLACE_GOLANG:-1}"
INJECT_CLASH_META="${INJECT_CLASH_META:-1}"

# ----------------------------
# 1. 替换新版 golang 包树（26.x）
# ----------------------------
if [ "${REPLACE_GOLANG}" = "1" ]; then
    echo "=== Replace golang feed (26.x) ==="
    rm -rf feeds/packages/lang/golang
    rm -rf package/feeds/packages/golang
    git clone --depth 1 https://github.com/sbwml/packages_lang_golang \
        -b 26.x feeds/packages/lang/golang
    ./scripts/feeds install -p packages golang
fi
# 清除旧值（防止 config.txt 里有残留的本地路径）
touch .config
sed -i '/^CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=/d' .config 2>/dev/null || true

# 只有 ARM64 本地环境才写入，GitHub Actions x86_64 自动跳过
ARCH="$(uname -m)"
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    if command -v go >/dev/null 2>&1; then
        GOROOT_PATH="$(go env GOROOT)"
        echo "=== ARM64 detected, setting Go bootstrap: ${GOROOT_PATH} ==="
        echo "CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=\"${GOROOT_PATH}\"" >> .config
    else
        echo "ERROR: ARM64 requires Go bootstrap but 'go' not found."
        exit 1
    fi
fi
# ----------------------------
# 2. 替换新版 mosdns（sbwml v5）
# ----------------------------
echo "=== Replace mosdns ==="
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf package/feeds/packages/mosdns
rm -rf package/feeds/luci/luci-app-mosdns
rm -rf package/mosdns
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns

# ----------------------------
# 3. 替换新版 v2ray-geodata
# ----------------------------
echo "=== Replace v2ray-geodata ==="
rm -rf feeds/packages/net/v2ray-geodata
rm -rf package/feeds/packages/v2ray-geodata
rm -rf package/v2ray-geodata
git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# 清除缓存索引
rm -rf tmp/

# ----------------------------
# 4. 修改默认管理 IP
# ----------------------------
echo "=== Set default IP to ${DEFAULT_IP} ==="
sed -i "s/192\.168\.1\.1/${DEFAULT_IP}/g" package/base-files/files/bin/config_generate || true
sed -i "s/192\.168\.6\.1/${DEFAULT_IP}/g" package/base-files/files/bin/config_generate || true

# ----------------------------
# 5. J1900 默认网络拓扑
# ----------------------------
if [ "${BUILD_TARGET}" = "J1900" ]; then
    echo "=== Injecting J1900 network topology ==="
    mkdir -p package/base-files/files/etc/uci-defaults/

    cat << NETWORK_EOF > package/base-files/files/etc/uci-defaults/99-custom-network
#!/bin/sh
uci -q batch <<UCI
set network.br_lan='device'
set network.br_lan.name='br-lan'
set network.br_lan.type='bridge'
delete network.br_lan.ports
add_list network.br_lan.ports='eth1'
add_list network.br_lan.ports='eth2'
add_list network.br_lan.ports='eth3'

set network.lan.device='br-lan'
set network.lan.proto='static'
set network.lan.ipaddr='${DEFAULT_IP}'
set network.lan.netmask='255.255.255.0'

set network.wan.device='eth0'
set network.wan.proto='${WAN_PROTO}'

set network.wan6.device='eth0'
set network.wan6.proto='dhcpv6'
UCI
uci commit network
exit 0
NETWORK_EOF
    chmod +x package/base-files/files/etc/uci-defaults/99-custom-network
fi

# ----------------------------
# 6. IPTV（仅 J1900 + SH51_85）
# ----------------------------
if [ "${BUILD_TARGET}" = "J1900" ] && [ "${IPTV_PROFILE}" = "SH51_85" ]; then
    echo "=== Injecting IPTV config: ${IPTV_PROFILE} ==="
    mkdir -p package/base-files/files/etc/uci-defaults/

    cat << 'IPTV_EOF' > package/base-files/files/etc/uci-defaults/99-custom-iptv
#!/bin/sh
uci -q batch <<UCI
# IPTV 51 bridge
set network.br_iptv51='device'
set network.br_iptv51.name='br-IPTV51'
set network.br_iptv51.type='bridge'
set network.br_iptv51.igmp_snooping='0'
delete network.br_iptv51.ports
add_list network.br_iptv51.ports='eth0.51'
add_list network.br_iptv51.ports='eth1.51'
add_list network.br_iptv51.ports='eth2.51'
add_list network.br_iptv51.ports='eth3.51'

set network.IPTV51='interface'
set network.IPTV51.proto='none'
set network.IPTV51.device='br-IPTV51'

# IPTV 85 bridge
set network.br_iptv85='device'
set network.br_iptv85.name='br-IPTV85'
set network.br_iptv85.type='bridge'
set network.br_iptv85.igmp_snooping='0'
delete network.br_iptv85.ports
add_list network.br_iptv85.ports='eth0.85'
add_list network.br_iptv85.ports='eth1.85'
add_list network.br_iptv85.ports='eth2.85'
add_list network.br_iptv85.ports='eth3.85'

set network.IPTV85='interface'
set network.IPTV85.proto='none'
set network.IPTV85.device='br-IPTV85'

# firewall zone IPTV51
set firewall.IPTV51='zone'
set firewall.IPTV51.name='IPTV51'
delete firewall.IPTV51.network
add_list firewall.IPTV51.network='IPTV51'
set firewall.IPTV51.input='ACCEPT'
set firewall.IPTV51.output='ACCEPT'
set firewall.IPTV51.forward='ACCEPT'

# firewall zone IPTV85
set firewall.IPTV85='zone'
set firewall.IPTV85.name='IPTV85'
delete firewall.IPTV85.network
add_list firewall.IPTV85.network='IPTV85'
set firewall.IPTV85.input='ACCEPT'
set firewall.IPTV85.output='ACCEPT'
set firewall.IPTV85.forward='ACCEPT'
UCI
uci commit network
uci commit firewall
exit 0
IPTV_EOF
    chmod +x package/base-files/files/etc/uci-defaults/99-custom-iptv
fi

# ----------------------------
# 7. 预置 OpenClash Meta 内核
# ----------------------------
if [ "${INJECT_CLASH_META}" = "1" ]; then
    echo "=== Injecting OpenClash Meta core ==="
    mkdir -p package/base-files/files/etc/openclash/core

    CORE_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz"

    if curl -L --retry 3 --retry-delay 5 --max-time 60 \
            -o /tmp/clash-linux-amd64.tar.gz "$CORE_URL"; then
        tar -xzf /tmp/clash-linux-amd64.tar.gz -C /tmp
        if [ -f /tmp/clash ]; then
            cp /tmp/clash package/base-files/files/etc/openclash/core/clash_meta
            chmod 0755 package/base-files/files/etc/openclash/core/clash_meta
            echo "=== Meta core injected successfully ==="
        else
            echo "WARNING: clash binary not found in tarball, skipping"
        fi
    else
        echo "WARNING: Failed to download Meta core, skipping"
    fi
fi

echo "=== diy-part2: done ==="
