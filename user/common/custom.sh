#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

source ../lib.sh

target=$1
echo "Execute common custom.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_target=${target_array[2]}
build_arch=${target_array[3]}
echo "source=${build_source}, type=${build_type}, target=${build_target}, arch=${build_arch}"

do_common() {
    # Set banner
    echo " Built on $(date +%Y-%m-%d)" >>files/etc/banner
    echo "" >>files/etc/banner
    mv -f files/etc/banner package/base-files/files/etc/banner

    # add OpenAppFilter
    rm -rf package/OpenAppFilter
    dl_git https://github.com/destan19/OpenAppFilter package/OpenAppFilter

    # replace smartdns
    rm -rf feeds/packages/net/smartdns
    dl_git_sub https://github.com/Lienol/openwrt-packages feeds/packages/net/smartdns net/smartdns master

    # replace mosdns
    rm -rf feeds/helloworld/mosdns
    rm -rf feeds/packages/net/mosdns
    dl_git_sub https://github.com/sbwml/luci-app-mosdns feeds/packages/net/mosdns mosdns v5
    rm -rf feeds/packages/net/mosdns/patches
    # use fork repo before PR accepted
    sed -i 's/^PKG_VERSION.*/PKG_VERSION:=44c8cc6/g' feeds/packages/net/mosdns/Makefile
    sed -i 's#IrineSistiana/mosdns/tar#alecthw/mosdns/tar#g' feeds/packages/net/mosdns/Makefile
    sed -i 's#v$(PKG_VERSION)#$(PKG_VERSION)#g' feeds/packages/net/mosdns/Makefile
    sed -i 's/^PKG_HASH.*/PKG_HASH:=skip/g' feeds/packages/net/mosdns/Makefile

    # add openclash
    rm -rf feeds/luci/applications/luci-app-openclash
    rm -rf package/luci-app-openclash
    dl_git_sub https://github.com/vernesong/OpenClash package/luci-app-openclash luci-app-openclash master
    sed -i "/dashboard_password/d" package/luci-app-openclash/root/etc/uci-defaults/luci-openclash
}

# excute
do_common

# excute custom for different source
source "../user/common/${build_source}.sh"
