#!/bin/bash

echo "Test custom.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git       package/luci-app-serverchan

rm -rf package/lean/luci-app-n2n_v2
rm -rf package/lean/n2n_v2
git clone https://github.com/alecthw/openwrt-n2n.git package/n2n

# clean default config of https-dns-proxy
cat > package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config << EOF
config main 'config'
	option update_dnsmasq_config ''
EOF

# set default theme
sed -i "/uci commit luci/i\uci set luci.main.mediaurlbase=/luci-static/material"  package/lean/default-settings/files/zzz-default-settings

# set lan ip
sed -i "/uci commit fstab/a\uci commit network"                                   package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.netmask='255.255.255.0'"          package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/a\uci set network.lan.ipaddr='192.168.11.1'"            package/lean/default-settings/files/zzz-default-settings
sed -i "/uci commit fstab/G"                                                      package/lean/default-settings/files/zzz-default-settings

# remove feeds repository
sed -i "/ustclug/i\sed -i '/helloworld/d' /etc/opkg/distfeeds.conf"               package/lean/default-settings/files/zzz-default-settings
sed -i "/ustclug/i\sed -i '/diy1/d' /etc/opkg/distfeeds.conf"                     package/lean/default-settings/files/zzz-default-settings

cat package/lean/default-settings/files/zzz-default-settings
