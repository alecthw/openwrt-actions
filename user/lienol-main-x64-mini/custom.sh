#!/bin/bash

echo "Test custom.sh"

# set default theme
sed -i "/luci.main.mediaurlbase/c\uci set luci.main.mediaurlbase=/luci-static/material" package/default-settings/files/zzz-default-settings

# set lan ip
sed -i "/^#uci set network.lan.ipaddr/c\uci set network.lan.ipaddr='192.168.11.1'"      package/default-settings/files/zzz-default-settings
sed -i "/^#uci set network.lan.netmask/c\uci set network.lan.netmask='255.255.255.0'"   package/default-settings/files/zzz-default-settings
sed -i "/^#uci commit network/c\uci commit network"                                     package/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/diy1/a\sed -i '/n2n/d' /etc/opkg/distfeeds.conf"                               package/default-settings/files/zzz-default-settings

# copy default config
if [ -d "package/lean/luci-app-adbyby-plus" ]; then
    cp -f ../user/lienol-main-x64-mini/defconfig/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
fi

if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
    cp -f ../user/lienol-main-x64-mini/defconfig/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
    cp -f ../user/lienol-main-x64-mini/defconfig/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/
fi

if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
    mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
    mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
    cp -f ../user/lienol-main-x64-mini/defconfig/etc/config/smartdns         package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
    cp -f ../user/lienol-main-x64-mini/defconfig/etc/smartdns/custom.conf    package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf 
fi

cat package/default-settings/files/zzz-default-settings
