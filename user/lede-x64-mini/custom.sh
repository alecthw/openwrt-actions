#!/bin/bash

echo "Execute custom custom.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
svn co https://github.com/Lienol/openwrt-packages/trunk/net/smartdns feeds/packages/net/smartdns

rm -rf feeds/packages/libs/libcap
svn co https://github.com/openwrt/packages/trunk/libs/libcap feeds/packages/libs/libcap

# clean default config of https-dns-proxy
cat >package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config <<EOF
config main 'config'
	option update_dnsmasq_config ''
EOF

cat package/lean/default-settings/files/zzz-default-settings
