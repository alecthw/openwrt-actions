#!/bin/bash

echo "Test custom.sh"

git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

sed -i "/uci commit fstab/a\uci commit network"                          package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.netmask='255.255.255.0'" package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.ipaddr='192.168.11.1'"   package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\ "                                           package/lean/default-settings/files/zzz-default-settings

cat package/lean/default-settings/files/zzz-default-settings
