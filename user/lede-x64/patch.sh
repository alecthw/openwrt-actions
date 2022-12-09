#!/bin/bash

# Execute before update feeds

echo "Execute custom patch.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/redsocks2 package/redsocks2
svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
