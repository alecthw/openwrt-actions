#!/bin/bash

# Execute before update feeds
# patch -> [update & install feeds] -> custom -> config

target=$1
echo "Execute common patch.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "Source: ${source}"

do_common() {
    # add custom packages
    rm -rf package/luci-theme-argon-jerrykuku
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku

    rm -rf package/luci-app-serverchan
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

    rm -rf package/OpenAppFilter
    git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
}

do_official_common() {
    echo ""
}

do_lede_common() {
    # add custom packages
    rm -rf package/luci-app-tcpdump
    svn co https://github.com/Lienol/openwrt-package/branches/other/luci-app-tcpdump package/luci-app-tcpdump

    rm -rf package/luci-app-adguardhome
    svn co https://github.com/Lienol/openwrt-package/branches/other/luci-app-adguardhome package/luci-app-adguardhome

    rm -rf package/luci-app-control-timewol package/luci-app-control-webrestriction package/luci-app-control-weburl package/luci-app-fileassistant package/luci-app-filebrowser package/luci-app-nginx-pingos
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/luci-app-control-timewol
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/luci-app-control-webrestriction
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/luci-app-control-weburl
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-fileassistant package/luci-app-fileassistant
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-nginx-pingos package/luci-app-nginx-pingos
}

# excute begin
do_common

case "${source}" in
official)
    echo "do official"
    do_official_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
