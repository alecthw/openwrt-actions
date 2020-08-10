#!/bin/bash

echo "Test custom.sh"

version=`date "+%m.%d"`
echo $1
sed -i '92d'                                                                   package/system/opkg/Makefile
sed -i '/lienol/d'                                                             package/default-settings/files/zzz-default-settings
sed -i '/shadow/d'                                                             package/default-settings/files/zzz-default-settings
sed -i "s/#sed/sed/g"                                                          package/default-settings/files/zzz-default-settings
sed -i "s/openwrt.proxy.ustclug.org/openwrt.download/g"                            package/default-settings/files/zzz-default-settings
sed -i "s/https/L20.8.6/g"                                                package/default-settings/files/zzz-default-settings
sed -i  's/http/releases\\\/19.07\-SNAPSHOT/g'                                 package/default-settings/files/zzz-default-settings
sed -i '/exit/d'                                                               package/default-settings/files/zzz-default-settings
echo "sed -i \"s/19.07-SNAPSHOT/L20.$version/g\" /etc/openwrt_release " >>     package/default-settings/files/zzz-default-settings
echo "exit 0" >>                                                               package/default-settings/files/zzz-default-settings
cat package/default-settings/files/zzz-default-settings

