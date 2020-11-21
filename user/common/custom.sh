#!/bin/bash

target=$1
echo "Execute common custom.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "source=${source}"

do_common() {
    # copy default config
    cp -f ../defconfig/zzz-extra-settings package/base-files/files/etc/uci-defaults/zzz-extra-settings

    if [ -d "package/lean/luci-app-adbyby-plus" ]; then
        cp -f ../defconfig/etc/config/adbyby package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
    fi

    if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
        cp -f ../defconfig/etc/config/passwall package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
        cp -rf ../defconfig/usr/share/passwall/* package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/
        chmod 775 package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/curl_ping.sh
        chmod 775 package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/test_node.sh
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
        cp -rf ../defconfig/etc/smartdns/* package/luci-app-smartdns/root/etc/smartdns/
    fi

    if [ -d "package/feeds/openclash/luci-app-openclash" ]; then
        cp -f ../defconfig/etc/config/openclash package/feeds/openclash/luci-app-openclash/root/etc/config/openclash
    fi
}

do_lienol_common() {
    echo ""
}

do_lede_common() {
    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings
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
