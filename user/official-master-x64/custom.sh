#!/bin/bash

echo "Test custom.sh"

# update upstream code
git pull https://github.com/openwrt/openwrt.git --log --no-commit

# copy default config
if [ -d "package/lean/luci-app-adbyby-plus" ]; then
    cp -f ../user/official-master-x64/defconfig/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
fi

if [ -d "package/feeds/openclash/luci-app-openclash" ]; then
    cp -f ../user/official-master-x64/defconfig/etc/config/openclash        package/feeds/openclash/luci-app-openclash/root/etc/config/openclash
fi

if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
    cp -f ../user/official-master-x64/defconfig/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
    cp -f ../user/official-master-x64/defconfig/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/
fi

if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
    mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
    mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
    cp -f ../user/official-master-x64/defconfig/etc/config/smartdns         package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
    cp -f ../user/official-master-x64/defconfig/etc/smartdns/custom.conf    package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf 
fi

# clean default config of https-dns-proxy
cat > package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config << EOF
config main 'config'
	option update_dnsmasq_config ''
EOF
