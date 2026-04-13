#!/bin/bash


# 只保留这一种 MosDNS 注入方式，防止重复
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;v5' >> feeds.conf.default
