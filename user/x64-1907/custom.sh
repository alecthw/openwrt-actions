#!/bin/bash

echo "Test custom.sh"

version=`date "+%m.%d"`
echo $1

sed -i "/^#uci set network.lan.ipaddr/cuci set network.lan.ipaddr='192.168.11.1'"    package/default-settings/files/zzz-default-settings
sed -i "/^#uci set network.lan.netmask/cuci set network.lan.netmask='255.255.255.0'" package/default-settings/files/zzz-default-settings
sed -i "/^#uci commit network/cuci commit network"                                   package/default-settings/files/zzz-default-settings

cat package/default-settings/files/zzz-default-settings
