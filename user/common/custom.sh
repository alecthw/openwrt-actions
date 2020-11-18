#!/bin/bash

target=$1
echo "Execute common custom.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "source=${source}"

do_common() {
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku

    # copy default config
    cp -f ../defconfig/zzz-extra-settings package/base-files/files/etc/uci-defaults/99-extra-settings

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
        cp -f ../defconfig/etc/smartdns/* package/luci-app-smartdns/root/etc/smartdns/
    fi

    if [ -d "package/feeds/openclash/luci-app-openclash" ]; then
        cp -f ../defconfig/etc/config/openclash package/feeds/openclash/luci-app-openclash/root/etc/config/openclash
    fi
}

do_lienol_common() {
    # add custom packages
    git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
}

do_lede_common() {
    # add custom packages
    svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-tcpdump package/luci-app-tcpdump

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
