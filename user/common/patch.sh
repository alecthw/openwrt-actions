#!/bin/bash

# Execute before update feeds

target=$1
echo "Execute common patch.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "Source: ${source}"

do_common() {
    # add custom packages
    git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

    git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
}

do_lienol_common() {
    # add custom packages
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku

    # n2n_v2
    svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-n2n package/luci-app-n2n
    svn co https://github.com/coolsnowwolf/packages/trunk/net/n2n package/n2n
}

do_lede_common() {
    # add custom packages
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku
    svn co https://github.com/Lienol/openwrt-package/branches/other/luci-app-tcpdump package/luci-app-tcpdump
    svn co https://github.com/Lienol/openwrt-package/branches/other/luci-app-adguardhome package/luci-app-adguardhome

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
