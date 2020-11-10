#!/bin/bash

echo "Test custom.sh"

# set default theme
sed -i "/uci commit luci/i\uci set luci.main.mediaurlbase=/luci-static/material"  package/lean/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/openwrt_luci/i\sed -i '/helloworld/d' /etc/opkg/distfeeds.conf"          package/lean/default-settings/files/zzz-default-settings
sed -i "/openwrt_luci/i\sed -i '/n2n/d' /etc/opkg/distfeeds.conf"                 package/lean/default-settings/files/zzz-default-settings
