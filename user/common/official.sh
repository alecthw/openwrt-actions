#!/bin/bash

echo "Current dir: $(pwd), Script: $0"

# Priority: package dir > feeds dir
do_official_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_git https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon-jerrykuku

    # replace feeds/luci/applications/luci-app-smartdns
    rm -rf package/luci-app-smartdns
    dl_git https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
}

# excute
do_official_common
