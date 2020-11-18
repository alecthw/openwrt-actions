#!/bin/bash

echo "Execute custom custom.sh"

# change packages
rm -rf feeds/packages/net/smartdns
svn co https://github.com/Lienol/openwrt-packages/trunk/net/smartdns feeds/packages/net/smartdns

rm -rf feeds/packages/libs/libcap
svn co https://github.com/openwrt/packages/trunk/libs/libcap feeds/packages/libs/libcap

git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

# clean default config of https-dns-proxy
cat >package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config <<EOF
config main 'config'
	option update_dnsmasq_config ''
EOF

cat package/lean/default-settings/files/zzz-default-settings
