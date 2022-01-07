#!/bin/bash

# Execute before update feeds

echo "Execute custom patch.sh"

# add custom packages
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
svn co https://github.com/Lienol/openwrt/trunk/package/libs/libcap package/libs/libcap
