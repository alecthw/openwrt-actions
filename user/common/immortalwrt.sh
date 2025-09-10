#!/bin/bash

echo "Current dir: $(pwd), Script: $0"

# Priority: package dir > feeds dir
do_immortalwrt_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

    # add v2dat for luci-app-mosdns
    rm -rf package/v2dat
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/v2dat v2dat v5

    # add luci-app-adguardhome
    rm -rf package/luci-app-adguardhome
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-app-adguardhome applications/luci-app-adguardhome openwrt-23.05

    # add luci-theme-design
    rm -rf package/luci-theme-design
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-theme-design themes/luci-theme-design openwrt-24.10

    # replace luci-app-zerotier
    rm -rf package/luci-app-zerotier
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-app-zerotier applications/luci-app-zerotier openwrt-24.10
    sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-zerotier/Makefile
    # replace zerotier
    rm -rf package/zerotier
    dl_git_sub https://github.com/coolsnowwolf/packages package/zerotier net/zerotier master

    # add daed
    rm -rf package/dae
    dl_git https://github.com/QiuSimons/luci-app-daed package/dae
    dl_git_sub https://github.com/immortalwrt/packages package/libcron libs/libcron master
}

# excute
do_immortalwrt_common
