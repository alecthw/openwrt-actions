#!/bin/bash

echo "Current dir: $(pwd), Script: $0"

# Priority: package dir > feeds dir
do_lede_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

    # Set revision
    sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings

    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings
    # delete 53 redirect
    sed -i '/REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_git https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon-jerrykuku 18.06

    # replace feeds/luci/applications/luci-app-mosdns
    rm -rf package/luci-app-mosdns
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns luci-app-mosdns v5-lua
    # sed -i 's#PROG start#PROG start -d /etc/mosdns#g' package/luci-app-mosdns/root/etc/init.d/mosdns

    # replace feeds/luci/applications/luci-app-smartdns
    rm -rf package/luci-app-smartdns
    dl_git https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns lede

    # add luci-app-tcpdump
    rm -rf package/luci-app-tcpdump
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-tcpdump luci-app-tcpdump other

    # replace feeds/packages/net/v2ray-geodata
    # rm -rf package/v2ray-geodata
    # dl_git_sub https://github.com/fw876/helloworld package/v2ray-geodata v2ray-geodata main

    # replace feeds/packages/utils/open-vm-tools
    # rm -rf package/open-vm-tools
    # dl_git_sub https://github.com/openwrt/packages package/open-vm-tools utils/open-vm-tools master

    # add luci-app-adguardhome, which is already included in lede, uss Lienol's replace
    rm -rf package/luci-app-adguardhome
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-adguardhome luci-app-adguardhome other

    # add other app
    rm -rf package/luci-app-control-timewol package/luci-app-control-webrestriction package/luci-app-control-weburl package/luci-app-fileassistant package/luci-app-filebrowser package/luci-app-nginx-pingos
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-control-timewol luci-app-control-timewol main
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-control-webrestriction luci-app-control-webrestriction main
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-control-weburl luci-app-control-weburl main
    # The following two packages are already included in lede
    # dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-fileassistant luci-app-fileassistant main
    # dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-filebrowser luci-app-filebrowser main
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-nginx-pingos luci-app-nginx-pingos main
}

# excute
do_lede_common
