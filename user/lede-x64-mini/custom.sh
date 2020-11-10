#!/bin/bash

echo "Test custom.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

# clean default config of https-dns-proxy
cat > package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config << EOF
config main 'config'
	option update_dnsmasq_config ''
EOF

# copy default config
if [ -d "package/lean/luci-app-adbyby-plus" ]; then
    cp -f ../defconfig/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
fi

if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
    cp -f ../defconfig/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
    cp -f ../defconfig/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/
fi

if [ -d "package/luci-app-smartdns" ]; then
    mkdir -p package/luci-app-smartdns/root/etc/config
    mkdir -p package/luci-app-smartdns/root/etc/smartdns
    cp -f ../defconfig/etc/config/smartdns         package/luci-app-smartdns/root/etc/config/smartdns
    cp -f ../defconfig/etc/smartdns/custom.conf    package/luci-app-smartdns/root/etc/smartdns/custom.conf 
fi

# set default theme
sed -i "/uci commit luci/i\uci set luci.main.mediaurlbase=/luci-static/material"  package/lean/default-settings/files/zzz-default-settings

# set lan ip
sed -i "/uci commit fstab/a\uci commit network"                                   package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.netmask='255.255.255.0'"          package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.ipaddr='192.168.11.1'"            package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/G"                                                      package/lean/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/ustclug/i\sed -i '/diy1/d' /etc/opkg/distfeeds.conf"                     package/lean/default-settings/files/zzz-default-settings
sed -i "/ustclug/i\sed -i '/n2n/d' /etc/opkg/distfeeds.conf"                     package/lean/default-settings/files/zzz-default-settings

cat package/lean/default-settings/files/zzz-default-settings
