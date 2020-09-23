#!/bin/bash

echo "Test custom.sh"

# add custom packages
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git       package/luci-app-serverchan

# set lan ip
sed -i "/^#uci set network.lan.ipaddr/cuci set network.lan.ipaddr='192.168.11.1'"    package/default-settings/files/zzz-default-settings
sed -i "/^#uci set network.lan.netmask/cuci set network.lan.netmask='255.255.255.0'" package/default-settings/files/zzz-default-settings
sed -i "/^#uci commit network/cuci commit network"                                   package/default-settings/files/zzz-default-settings

cat package/default-settings/files/zzz-default-settings
