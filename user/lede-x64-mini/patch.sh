#!/bin/bash

echo "Execute custom patch.sh"

# xiaorouji lienol
rm -rf package/lean/luci-app-guest-wifi
#rm -rf package/lean/luci-app-kodexplorer
rm -rf package/lean/luci-app-pppoe-relay
#rm -rf package/lean/luci-app-ramfree
rm -rf package/lean/luci-app-softethervpn

# xiaorouji obsolete
rm -rf package/lean/luci-app-v2ray-server
#rm -rf package/lean/luci-app-verysync

# xiaorouji package
#rm -rf package/lean/dns2socks
#rm -rf package/lean/ipt2socks
#rm -rf package/lean/kcptun
rm -rf package/lean/microsocks
#rm -rf package/lean/pdnsd-alt
#rm -rf package/lean/shadowsocksr-libev
#rm -rf package/lean/simple-obfs
rm -rf package/lean/trojan
#rm -rf package/lean/v2ray
#rm -rf package/lean/v2ray-plugin
#rm -rf package/lean/verysync
