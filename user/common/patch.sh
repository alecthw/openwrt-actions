#!/bin/bash

# Execute before update feeds

target=$1
echo "Execute common patch.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "Source: ${source}"

do_common() {
    # add custom packages
    git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku
    git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
    git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
}

do_lienol_common() {
    rm -rf package/diy/OpenAppFilter
    git clone https://github.com/Lienol/openwrt.git package/diy/OpenAppFilter
}

do_lede_common() {
    # add custom packages
    git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

    svn co https://github.com/Lienol/openwrt/trunk/package/diy/luci-app-tcpdump package/luci-app-tcpdump
    svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/luci-app-control-webrestriction

    # remove pkg
    rm -rf package/lean/luci-app-n2n_v2
    rm -rf package/lean/n2n_v2
    rm -rf package/lean/luci-app-jd-dailybonus
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
