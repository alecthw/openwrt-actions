#!/bin/bash

do_official_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

    # add luci-theme-argon-jerrykuku
    rm -rf package/luci-theme-argon-jerrykuku
    dl_git https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon-jerrykuku

    # replace luci-app-smartdns
    rm -rf feeds/luci/applications/luci-app-smartdns
    dl_git https://github.com/pymumu/luci-app-smartdns feeds/luci/applications/luci-app-smartdns
}

# excute
do_official_common
