#!/bin/bash

# Execute before update feeds
# patch -> [update & install feeds] -> custom -> config

echo "Execute custom patch.sh"

# add custom packages
rm -rf package/luci-app-smartdns
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

rm -rf package/luci-app-ssr-plus package/redsocks2 package/lua-neturl package/luci-app-openclash
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/redsocks2 package/redsocks2
svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

rm -rf package/lua-maxminddb package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
