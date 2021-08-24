#!/bin/bash

# Execute before update feeds

echo "Execute custom patch.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# duplicate packages in passwall
rm -rf package/lean/dns2socks
rm -rf package/lean/ipt2socks
rm -rf package/lean/microsocks
rm -rf package/lean/pdnsd-alt
rm -rf package/lean/simple-obfs
rm -rf package/lean/trojan