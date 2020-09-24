#!/bin/bash

echo "Test custom.sh"

# copy default config
cp -f ../user/official-master-x64/defconfig/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby

cp -f ../user/official-master-x64/defconfig/etc/config/openclash        package/feeds/openclash/luci-app-openclash/root/etc/config/openclash

cp -f ../user/official-master-x64/defconfig/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
cp -f ../user/official-master-x64/defconfig/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/

mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
cp -f ../user/official-master-x64/defconfig/etc/config/smartdns         package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
cp -f ../user/official-master-x64/defconfig/etc/smartdns/custom.conf    package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf 