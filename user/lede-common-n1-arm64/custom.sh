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

echo "Execute custom custom.sh"

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Add luci-app-amlogic
dl_git_sub https://github.com/ophub/luci-app-amlogic package/luci-app-amlogic luci-app-amlogic main
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/alecthw/openwrt-actions'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|lede-common-n1|g" package/luci-app-amlogic/root/etc/config/amlogic

cat package/lean/default-settings/files/zzz-default-settings
