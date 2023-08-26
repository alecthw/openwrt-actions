#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

echo "Execute custom custom.sh"

# replace dns2socks
rm -rf feeds/packages/net/dns2socks
svn co -q https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks feeds/packages/net/dns2socks

# replace microsocks
rm -rf feeds/packages/net/microsocks
svn co -q https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks feeds/packages/net/microsocks

# replace pdnsd-alt
rm -rf feeds/packages/net/pdnsd-alt
svn co -q https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt feeds/packages/net/pdnsd-alt

# add ssrp
rm -rf package/luci-app-ssr-plus package/redsocks2 package/lua-neturl
svn co -q https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co -q https://github.com/fw876/helloworld/trunk/redsocks2 package/redsocks2
svn co -q https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl

# add openclash
rm -rf package/luci-app-openclash
svn co -q https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash

# add vssr
rm -rf package/lua-maxminddb package/luci-app-vssr
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr

cat package/lean/default-settings/files/zzz-default-settings
