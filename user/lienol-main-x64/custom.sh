#!/bin/bash

echo "Execute custom custom.sh"

# add custom packages
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/tty228/luci-app-serverchan.git       package/luci-app-serverchan

cat package/default-settings/files/zzz-default-settings
