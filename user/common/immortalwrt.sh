#!/bin/bash

# Priority: package dir > feeds dir
do_immortalwrt_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_git https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon-jerrykuku

    # add luci-app-mosdns
    rm -rf package/luci-app-mosdns
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns luci-app-mosdns v5
    rm -rf package/v2dat
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/v2dat v2dat v5

    # replace feeds/luci/applications/luci-app-smartdns
    rm -rf package/luci-app-smartdns
    dl_git https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns lede

    # add luci-app-tcpdump
    rm -rf package/luci-app-tcpdump
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-tcpdump luci-app-tcpdump other

    # add luci-app-adguardhome
    rm -rf package/luci-app-adguardhome
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-adguardhome luci-app-adguardhome other

    # add other app
    rm -rf package/luci-app-nginx-pingos
    dl_git_sub https://github.com/Lienol/openwrt-package package/luci-app-nginx-pingos luci-app-nginx-pingos main
}

# excute
do_immortalwrt_common
