#!/bin/bash

# Execute after install feeds

echo "Execute custom custom.sh"

# change packages
rm -rf feeds/packages/net/xray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core feeds/packages/net/xray-core

cat package/default-settings/files/zzz-default-settings
