#!/bin/bash

# Execute before update feeds

echo "Execute custom patch.sh"

# add custom packages
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

# duplicate packages in passwall
rm -rf package/lean/dns2socks
rm -rf package/lean/ipt2socks
rm -rf package/lean/microsocks
rm -rf package/lean/pdnsd-alt
rm -rf package/lean/simple-obfs
rm -rf package/lean/trojan