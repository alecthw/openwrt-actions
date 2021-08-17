#!/bin/bash

# Execute after install feeds

echo "Execute custom custom.sh"

# change packages
rm -rf feeds/packages/net/smartdns
svn co https://github.com/Lienol/openwrt-packages/trunk/net/smartdns feeds/packages/net/smartdns

rm -rf feeds/packages/net/kcptun
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/kcptun feeds/packages/net/kcptun

cat package/lean/default-settings/files/zzz-default-settings
