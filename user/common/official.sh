#!/bin/bash

echo "Current dir: $(pwd), Script: $0"

# Priority: package dir > feeds dir
do_official_common() {
    # Set openwrt_release
    echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

    # add daed
    rm -rf package/dae
    dl_git https://github.com/QiuSimons/luci-app-daed package/dae
    dl_git_sub https://github.com/immortalwrt/packages package/libcron libs/libcron master
}

# excute
do_official_common
