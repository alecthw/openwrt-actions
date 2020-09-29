#!/bin/bash

echo "Test custom.sh"

# golang version
sed -i "/^GO_VERSION_MAJOR_MINOR/c\GO_VERSION_MAJOR_MINOR:=1.15"                                 package/feeds/packages/golang/golang/Makefile
sed -i "/^GO_VERSION_PATCH/c\GO_VERSION_PATCH:=2"                                                package/feeds/packages/golang/golang/Makefile
sed -i "/^PKG_HASH/c\PKG_HASH:=28bf9d0bcde251011caae230a4a05d917b172ea203f2a62f2c2f9533589d4b4d" package/feeds/packages/golang/golang/Makefile

# copy default config
cp -f ../user/official-master-x64/defconfig/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby

cp -f ../user/official-master-x64/defconfig/etc/config/openclash        package/feeds/openclash/luci-app-openclash/root/etc/config/openclash

cp -f ../user/official-master-x64/defconfig/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
cp -f ../user/official-master-x64/defconfig/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/

mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
cp -f ../user/official-master-x64/defconfig/etc/config/smartdns         package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
cp -f ../user/official-master-x64/defconfig/etc/smartdns/custom.conf    package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf 

# clean default config of https-dns-proxy
cat > package/feeds/packages/https-dns-proxy/files/https-dns-proxy.config << EOF
config main 'config'
	option update_dnsmasq_config ''
EOF
