#!/bin/bash

echo "Current dir: $(pwd), Script: $0"

# Priority: package dir > feeds dir
do_official_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

    # replace include/target.mk
    dl_curl https://raw.githubusercontent.com/immortalwrt/immortalwrt/refs/heads/openwrt-24.10/include/target.mk include/target.mk

    # add v2dat for luci-app-mosdns
    rm -rf package/v2dat
    dl_git_sub https://github.com/sbwml/luci-app-mosdns package/v2dat v2dat v5

    # add luci-app-adguardhome
    rm -rf package/luci-app-adguardhome
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-app-adguardhome applications/luci-app-adguardhome openwrt-23.05

    # add luci-theme-design
    rm -rf package/luci-theme-design
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-theme-design themes/luci-theme-design openwrt-23.05

    # replace luci-app-zerotier
    rm -rf package/luci-app-zerotier
    dl_git_sub https://github.com/coolsnowwolf/luci package/luci-app-zerotier applications/luci-app-zerotier openwrt-23.05
    sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-zerotier/Makefile

    # add emortal packages
    rm -rf package/emortal
    dl_git_sub https://github.com/immortalwrt/immortalwrt package/emortal package/emortal openwrt-24.10

    # add luci-app-autoreboot
    rm -rf package/luci-app-autoreboot
    dl_git_sub https://github.com/immortalwrt/luci package/luci-app-autoreboot applications/luci-app-autoreboot openwrt-24.10
    sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-autoreboot/Makefile

    # add luci-app-ramfree
    rm -rf package/luci-app-ramfree
    dl_git_sub https://github.com/immortalwrt/luci package/luci-app-ramfree applications/luci-app-ramfree openwrt-24.10
    sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-ramfree/Makefile

    # add luci-app-vlmcsd
    rm -rf package/luci-app-vlmcsd
    dl_git_sub https://github.com/immortalwrt/luci package/luci-app-vlmcsd applications/luci-app-vlmcsd openwrt-24.10
    sed -i 's#../../luci.mk#$(TOPDIR)/feeds/luci/luci.mk#g' package/luci-app-vlmcsd/Makefile

    # add vlmcsd
    rm -rf package/vlmcsd
    dl_git_sub https://github.com/immortalwrt/packages package/vlmcsd net/vlmcsd openwrt-24.10

    # add ddns-scripts_aliyun
    rm -rf package/ddns-scripts_aliyun
    dl_git_sub https://github.com/immortalwrt/packages package/ddns-scripts_aliyun net/ddns-scripts_aliyun openwrt-24.10
}

# excute
do_official_common
