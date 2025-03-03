#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

echo "Current dir: $(pwd), Script: $0"

if [ -z "${GITHUB_WORKSPACE}" ]; then
    echo "GITHUB_WORKSPACE not set"
    GITHUB_WORKSPACE=$(
        cd $(dirname $0)/../..
        pwd
    )
    export GITHUB_WORKSPACE
fi

source $GITHUB_WORKSPACE/lib.sh

target=$1
echo "Execute common custom.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_target=${target_array[2]}
build_arch=${target_array[3]}
echo "source=${build_source}, type=${build_type}, target=${build_target}, arch=${build_arch}"

# Priority: package dir > feeds dir
do_common() {
    # Set banner
    echo " Built on $(date +%Y-%m-%d)" >>files/etc/banner
    echo "" >>files/etc/banner
    mv -f files/etc/banner package/base-files/files/etc/banner

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_git https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon-jerrykuku

    # replace feeds/luci/applications/luci-app-smartdns
    # rm -rf package/luci-app-smartdns
    # dl_git https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
    # sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-smartdns/Makefile

    # add/replace feeds/luci/applications/luci-app-mosdns
    rm -rf package/luci-app-mosdns
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns luci-app-mosdns v5

    # replace feeds/helloworld/mosdns, feeds/packages/net/mosdns
    rm -rf package/mosdns
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/mosdns mosdns v5
    rm -rf package/mosdns/patches
    # use fork repo before PR accepted
    sed -i 's/^PKG_VERSION.*/PKG_VERSION:=7d80823/g' package/mosdns/Makefile
    sed -i 's#IrineSistiana/mosdns/tar#alecthw/mosdns/tar#g' package/mosdns/Makefile
    sed -i 's#v$(PKG_VERSION)#$(PKG_VERSION)#g' package/mosdns/Makefile
    sed -i 's/^PKG_HASH.*/PKG_HASH:=skip/g' package/mosdns/Makefile

    # add openclash | replace feeds/luci/applications/luci-app-openclash
    rm -rf package/luci-app-openclash
    dl_git_sub https://github.com/vernesong/OpenClash package/luci-app-openclash luci-app-openclash master
    sed -i "/dashboard_password/d" package/luci-app-openclash/root/etc/uci-defaults/luci-openclash

    # add OpenAppFilter
    # rm -rf package/OpenAppFilter
    # dl_git https://github.com/destan19/OpenAppFilter package/OpenAppFilter
}

# excute
do_common

# excute custom for different source
source "$GITHUB_WORKSPACE/user/common/${build_source}.sh"
