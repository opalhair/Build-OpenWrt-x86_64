#!/bin/bash
# 替换 Golang 包为 sbwml 的 24.x 高版本（确保 ddns-go 编译成功）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 只保留这一种 MosDNS 注入方式，防止重复
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;v5' >> feeds.conf.default
