#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

target=$1
echo "Execute common custom.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_arch=${target_array[2]}
echo "source=${build_source}, type=${build_type}, arch=${build_arch}"

do_common() {
    # add OpenAppFilter
    rm -rf package/OpenAppFilter
    git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

    # replace luci-app-smartdns
    rm -rf feeds/luci/applications/luci-app-smartdns
    git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns.git feeds/luci/applications/luci-app-smartdns

    # replace smartdns
    rm -rf feeds/packages/net/smartdns
    svn co -q https://github.com/Lienol/openwrt-packages/branches/master/net/smartdns feeds/packages/net/smartdns
}

do_official_common() {
    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon-jerrykuku

    # add luci-app-mosdns
    rm -rf package/luci-app-mosdns
    svn co https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns package/luci-app-mosdns
    # sed -i 's#PROG start#PROG start -d /etc/mosdns#g' package/luci-app-mosdns/root/etc/init.d/mosdns

    # add mosdns
    rm -rf package/mosdns
    svn co https://github.com/sbwml/luci-app-mosdns/trunk/mosdns package/mosdns
    rm -rf package/mosdns/patches
    # use fork repo before PR accepted
    sed -i 's/^PKG_VERSION.*/PKG_VERSION:=fa4996c/g' package/mosdns/Makefile
    sed -i 's#IrineSistiana/mosdns/tar#alecthw/mosdns/tar#g' package/mosdns/Makefile
    sed -i 's#v$(PKG_VERSION)#$(PKG_VERSION)#g' package/mosdns/Makefile
    sed -i 's/^PKG_HASH.*/PKG_HASH:=skip/g' package/mosdns/Makefile
}

do_lede_common() {
    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings
    # delete 53 redirect
    sed -i '/REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git -b 18.06 package/luci-theme-argon-jerrykuku

    # add luci-app-tcpdump
    rm -rf package/luci-app-tcpdump
    svn co -q https://github.com/Lienol/openwrt-package/branches/other/luci-app-tcpdump package/luci-app-tcpdump

    # replace v2ray-geodata
    rm -rf feeds/packages/net/v2ray-geodata
    svn co https://github.com/fw876/helloworld/trunk/v2ray-geodata feeds/packages/net/v2ray-geodata

    # replace open-vm-tools
    rm -rf feeds/packages/utils/open-vm-tools
    svn co -q https://github.com/openwrt/packages/trunk/utils/open-vm-tools feeds/packages/utils/open-vm-tools

    # replace glib2
    rm -rf feeds/packages/libs/glib2
    svn co -q https://github.com/openwrt/packages/trunk/libs/glib2 feeds/packages/libs/glib2

    # replace luci-app-mosdns
    rm -rf feeds/luci/applications/luci-app-mosdns
    svn co https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns feeds/luci/applications/luci-app-mosdns
    # sed -i 's#PROG start#PROG start -d /etc/mosdns#g' feeds/luci/applications/luci-app-mosdns/root/etc/init.d/mosdns

    # replace mosdns
    rm -rf feeds/packages/net/mosdns
    svn co https://github.com/sbwml/luci-app-mosdns/trunk/mosdns feeds/packages/net/mosdns
    rm -rf feeds/packages/net/mosdns/patches
    # use fork repo before PR accepted
    sed -i 's/^PKG_VERSION.*/PKG_VERSION:=fa4996c/g' feeds/packages/net/mosdns/Makefile
    sed -i 's#IrineSistiana/mosdns/tar#alecthw/mosdns/tar#g' feeds/packages/net/mosdns/Makefile
    sed -i 's#v$(PKG_VERSION)#$(PKG_VERSION)#g' feeds/packages/net/mosdns/Makefile
    sed -i 's/^PKG_HASH.*/PKG_HASH:=skip/g' feeds/packages/net/mosdns/Makefile

    # add luci-app-adguardhome
    rm -rf package/luci-app-adguardhome
    svn co -q https://github.com/Lienol/openwrt-package/branches/other/luci-app-adguardhome package/luci-app-adguardhome

    # add other app
    rm -rf package/luci-app-control-timewol package/luci-app-control-webrestriction package/luci-app-control-weburl package/luci-app-fileassistant package/luci-app-filebrowser package/luci-app-nginx-pingos
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/luci-app-control-timewol
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/luci-app-control-webrestriction
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/luci-app-control-weburl
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-fileassistant package/luci-app-fileassistant
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
    svn co -q https://github.com/Lienol/openwrt-package/trunk/luci-app-nginx-pingos package/luci-app-nginx-pingos
}

# excute begin
do_common

case "${build_source}" in
official)
    echo "do official"
    do_official_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${build_source}!"
    ;;
esac
