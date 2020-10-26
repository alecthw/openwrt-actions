#!/bin/bash

echo "Test custom.sh"

# add custom packages
rm -rf package/lean/luci-app-n2n_v2
rm -rf package/lean/n2n_v2
git clone https://github.com/alecthw/openwrt-n2n.git package/n2n

# set default theme
sed -i "/uci commit luci/i\uci set luci.main.mediaurlbase=/luci-static/material"  package/lean/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/ustclug/i\sed -i '/helloworld/d' /etc/opkg/distfeeds.conf"               package/lean/default-settings/files/zzz-default-settings
