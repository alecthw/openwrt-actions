#!/bin/bash

target=$1
echo "Execute common custom.sh ${target}"

array=(${target//-/ })
source=${array[0]}
system=${array[1]}
mini=${array[2]}
echo "source=${source}, system=${system}, mini=${mini}"

do_common() {
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku

    # copy default config
    if [ -d "package/lean/luci-app-adbyby-plus" ]; then
        cp -f ../defconfig/etc/config/adbyby package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
    fi

    if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
        cp -f ../defconfig/etc/config/passwall package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
        cp -f ../defconfig/usr/share/passwall/rules/* package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/
    fi

    if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
        cp -f ../defconfig/etc/config/smartdns package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
        cp -f ../defconfig/etc/smartdns/custom.conf package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf
    fi

    if [ -d "package/luci-app-smartdns" ]; then
        mkdir -p package/luci-app-smartdns/root/etc/config
        mkdir -p package/luci-app-smartdns/root/etc/smartdns
        cp -f ../defconfig/etc/config/smartdns package/luci-app-smartdns/root/etc/config/smartdns
        cp -f ../defconfig/etc/smartdns/custom.conf package/luci-app-smartdns/root/etc/smartdns/custom.conf
    fi
}

do_lienol_common() {
    # set default theme
    sed -i "/luci.main.mediaurlbase/c\uci set luci.main.mediaurlbase=/luci-static/material" package/default-settings/files/zzz-default-settings

    # set lan ip
    sed -i "/^#uci set network.lan.ipaddr/c\uci set network.lan.ipaddr='192.168.11.1'" package/default-settings/files/zzz-default-settings
    sed -i "/^#uci set network.lan.netmask/c\uci set network.lan.netmask='255.255.255.0'" package/default-settings/files/zzz-default-settings
    sed -i "/^#uci commit network/c\uci commit network" package/default-settings/files/zzz-default-settings

    # remove feeds repository
    sed -i "/diy1/a\sed -i '/n2n/d' /etc/opkg/distfeeds.conf" package/default-settings/files/zzz-default-settings
}

do_lede_common() {
    # add custom packages
    svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-tcpdump package/luci-app-tcpdump

    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings

    # set default theme
    sed -i "/uci commit luci/i\uci set luci.main.mediaurlbase=/luci-static/material" package/lean/default-settings/files/zzz-default-settings

    # set lan ip
    sed -i "/uci commit fstab/a\uci commit network" package/lean/default-settings/files/zzz-default-settings
    sed -i "/uci commit fstab/a\uci set network.lan.netmask='255.255.255.0'" package/lean/default-settings/files/zzz-default-settings
    sed -i "/uci commit fstab/a\uci set network.lan.ipaddr='192.168.11.1'" package/lean/default-settings/files/zzz-default-settings
    sed -i "/uci commit fstab/G" package/lean/default-settings/files/zzz-default-settings

    # remove feeds repository
    sed -i "/openwrt_luci/i\sed -i '/helloworld/d' /etc/opkg/distfeeds.conf" package/lean/default-settings/files/zzz-default-settings
    sed -i "/openwrt_luci/i\sed -i '/diy1/d' /etc/opkg/distfeeds.conf" package/lean/default-settings/files/zzz-default-settings
    sed -i "/openwrt_luci/i\sed -i '/n2n/d' /etc/opkg/distfeeds.conf" package/lean/default-settings/files/zzz-default-settings
}

do_add_firewall_zone() {
    sed -i "/'lan'/a\	list   network		'n2n0'" package/network/config/firewall/files/firewall.config
    sed -i "/'wan6'/a\	list   network		'iptv'" package/network/config/firewall/files/firewall.config
}

# excute begin
do_common

case "${source}" in
lienol)
    echo "do lienol"
    do_lienol_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
