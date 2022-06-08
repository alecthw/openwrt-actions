#!/bin/bash

# Execute after install feeds

echo "Execute custom custom.sh"

# change packages
rm -rf feeds/packages/net/smartdns
svn co https://github.com/Lienol/openwrt-packages/branches/master/net/smartdns feeds/packages/net/smartdns

rm -rf feeds/packages/net/dns2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks feeds/packages/net/dns2socks

rm -rf feeds/packages/net/microsocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks feeds/packages/net/microsocks

rm -rf feeds/packages/net/pdnsd-alt
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt feeds/packages/net/pdnsd-alt

cat package/lean/default-settings/files/zzz-default-settings
