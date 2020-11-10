#!/bin/bash

echo "Apply custom.sh"

git clone https://github.com/jerrykuku/luci-theme-argon.git -b 18.06    package/luci-theme-argon-jerrykuku

# add custom firewall zone
#sed -i "/'lan'/a\	list   network		'n2n0'"    package/network/config/firewall/files/firewall.config
#sed -i "/'wan6'/a\	list   network		'iptv'"    package/network/config/firewall/files/firewall.config
