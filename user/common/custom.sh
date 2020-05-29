#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

source ../lib.sh

target=$1
echo "Execute common custom.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_arch=${target_array[2]}
echo "source=${build_source}, type=${build_type}, arch=${build_arch}"

do_common() {
    # Set banner
    echo " Built on $(date +%Y-%m-%d)" >> files/etc/banner

    # Set openwrt_release
    sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings

    # add OpenAppFilter
    rm -rf package/OpenAppFilter
    dl_svn https://github.com/destan19/OpenAppFilter/trunk package/OpenAppFilter

    # replace smartdns
    rm -rf feeds/packages/net/smartdns
    dl_svn https://github.com/Lienol/openwrt-packages/branches/master/net/smartdns feeds/packages/net/smartdns

    # replace/add luci-app-mosdns
    rm -rf feeds/luci/applications/luci-app-mosdns
    dl_svn https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns feeds/luci/applications/luci-app-mosdns
    # sed -i 's#PROG start#PROG start -d /etc/mosdns#g' feeds/luci/applications/luci-app-mosdns/root/etc/init.d/mosdns

    # replace mosdns
    rm -rf feeds/packages/net/mosdns
    dl_svn https://github.com/sbwml/luci-app-mosdns/trunk/mosdns feeds/packages/net/mosdns
    rm -rf feeds/packages/net/mosdns/patches
    # use fork repo before PR accepted
    sed -i 's/^PKG_VERSION.*/PKG_VERSION:=fa4996c/g' feeds/packages/net/mosdns/Makefile
    sed -i 's#IrineSistiana/mosdns/tar#alecthw/mosdns/tar#g' feeds/packages/net/mosdns/Makefile
    sed -i 's#v$(PKG_VERSION)#$(PKG_VERSION)#g' feeds/packages/net/mosdns/Makefile
    sed -i 's/^PKG_HASH.*/PKG_HASH:=skip/g' feeds/packages/net/mosdns/Makefile

    # add openclash
    rm -rf package/luci-app-openclash
    dl_svn https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
}

do_official_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_svn https://github.com/jerrykuku/luci-theme-argon/trunk package/luci-theme-argon-jerrykuku

    # replace luci-app-smartdns
    rm -rf feeds/luci/applications/luci-app-smartdns
    dl_svn https://github.com/pymumu/luci-app-smartdns/trunk feeds/luci/applications/luci-app-smartdns
}

do_lede_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings
    # delete 53 redirect
    sed -i '/REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_svn https://github.com/jerrykuku/luci-theme-argon/branches/18.06 package/luci-theme-argon-jerrykuku

    # replace luci-app-smartdns
    rm -rf feeds/luci/applications/luci-app-smartdns
    dl_svn https://github.com/pymumu/luci-app-smartdns/branches/lede feeds/luci/applications/luci-app-smartdns

    # add luci-app-tcpdump
    rm -rf package/luci-app-tcpdump
    dl_svn https://github.com/Lienol/openwrt-package/branches/other/luci-app-tcpdump package/luci-app-tcpdump

    # replace v2ray-geodata
    rm -rf feeds/packages/net/v2ray-geodata
    dl_svn https://github.com/fw876/helloworld/trunk/v2ray-geodata feeds/packages/net/v2ray-geodata

    # replace open-vm-tools
    rm -rf feeds/packages/utils/open-vm-tools
    dl_svn https://github.com/openwrt/packages/trunk/utils/open-vm-tools feeds/packages/utils/open-vm-tools

    # replace glib2
    rm -rf feeds/packages/libs/glib2
    dl_svn https://github.com/openwrt/packages/trunk/libs/glib2 feeds/packages/libs/glib2

    # replace pcre2
    rm -rf feeds/packages/libs/pcre2
    dl_svn https://github.com/openwrt/openwrt/trunk/package/libs/pcre2 feeds/packages/libs/pcre2

    # add luci-app-adguardhome
    rm -rf package/luci-app-adguardhome
    dl_svn https://github.com/Lienol/openwrt-package/branches/other/luci-app-adguardhome package/luci-app-adguardhome

    # add other app
    rm -rf package/luci-app-control-timewol package/luci-app-control-webrestriction package/luci-app-control-weburl package/luci-app-fileassistant package/luci-app-filebrowser package/luci-app-nginx-pingos
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/luci-app-control-timewol
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/luci-app-control-webrestriction
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/luci-app-control-weburl
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-fileassistant package/luci-app-fileassistant
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser
    dl_svn https://github.com/Lienol/openwrt-package/trunk/luci-app-nginx-pingos package/luci-app-nginx-pingos
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
