#!/bin/bash

# Execute after install feeds

echo "Execute custom custom.sh"

# change packages
rm -rf feeds/packages/net/shadowsocksr-libev
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocksr-libev feeds/packages/net/shadowsocksr-libev

cat package/lean/default-settings/files/zzz-default-settings
