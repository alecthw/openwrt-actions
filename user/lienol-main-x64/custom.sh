#!/bin/bash

echo "Test custom.sh"

# add custom packages
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git       package/luci-app-serverchan

sed -i "/luci.main.mediaurlbase/c\uci set luci.main.mediaurlbase=/luci-static/material" package/default-settings/files/zzz-default-settings

# set lan ip
sed -i "/^#uci set network.lan.ipaddr/c\uci set network.lan.ipaddr='192.168.11.1'"      package/default-settings/files/zzz-default-settings
sed -i "/^#uci set network.lan.netmask/c\uci set network.lan.netmask='255.255.255.0'"   package/default-settings/files/zzz-default-settings
sed -i "/^#uci commit network/c\uci commit network"                                     package/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/diy1/a\sed -i '/n2n/d' /etc/opkg/distfeeds.conf"                               package/default-settings/files/zzz-default-settings

cat package/default-settings/files/zzz-default-settings
