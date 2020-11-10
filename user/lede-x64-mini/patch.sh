#!/bin/bash

echo "Test patch.sh"

# remove n2n
rm -rf package/lean/luci-app-n2n_v2
rm -rf package/lean/n2n_v2

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

# luci-app-tcpdump
curl https://codeload.github.com/Lienol/openwrt/zip/19.07 -o lienol.zip
unzip -q lienol.zip -d lienol
cp -rf lienol/openwrt-19.07/package/diy/luci-app-tcpdump package/
rm -rf lienol*
