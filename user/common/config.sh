#!/bin/bash

# Execute after install feeds as the last script
# patch -> [update & install feeds] -> custom -> config

target=$1
echo "Execute common config.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_arch=${target_array[2]}
echo "source=${build_source}, type=${build_type}, arch=${build_arch}"

# copy default config
if [ -d "../defconfig" ]; then
    cp -f ../defconfig/zzz-extra-settings package/base-files/files/etc/uci-defaults/zzzz-extra-settings

    if [ "${build_type}" != "openclash" ]; then
        cp -f ../defconfig/etc/firewall.user package/network/config/firewall/files/firewall.user
    else
        # special for openclash
        cp -f ../defconfig/etc/firewall_openclash.user package/network/config/firewall/files/firewall.user
    fi

    if [ -d "package/feeds/packages/nginx-util" ]; then
        cp -f ../defconfig/etc/config/nginx package/feeds/packages/nginx-util/files/nginx.config
    fi

    if [ -d "package/feeds/luci/luci-app-adbyby-plus" ]; then
        cp -f ../defconfig/etc/config/adbyby package/feeds/luci/luci-app-adbyby-plus/root/etc/config/adbyby
    fi
    if [ -d "package/feeds/other/luci-app-adbyby-plus" ]; then
        cp -f ../defconfig/etc/config/adbyby package/feeds/other/luci-app-adbyby-plus/root/etc/config/adbyby
    fi

    if [ -d "package/feeds/passwall/luci-app-passwall" ]; then
        # cp -f ../defconfig/etc/config/passwall package/feeds/passwall/luci-app-passwall/root/etc/config/passwall
        cp -rf ../defconfig/usr/share/passwall/* package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/
        chmod 775 package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/curl_ping.sh
        chmod 775 package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/test_node.sh

        mkdir package/feeds/passwall/luci-app-passwall/root/usr/share/geodata
        curl -kL --retry 3 --connect-timeout 3 -o package/feeds/passwall/luci-app-passwall/root/usr/share/geodata/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
        curl -kL --retry 3 --connect-timeout 3 -o package/feeds/passwall/luci-app-passwall/root/usr/share/geodata/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
    fi

    if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
        if [ "${build_type}" != "openclash" ]; then
            cp -f ../defconfig/etc/config/smartdns package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
            cp -rf ../defconfig/etc/smartdns/custom.conf package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf
        else
            # special for openclash
            cp -f ../defconfig/etc/config/smartdns_openclash package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
            cp -rf ../defconfig/etc/smartdns/custom_openclash.conf package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf
        fi
        cp -rf ../defconfig/etc/smartdns/anti-ad.sh package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
        if [ -f "package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh" ]; then
            curl -kL --retry 3 --connect-timeout 3 -o package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad-smartdns.conf https://anti-ad.net/anti-ad-for-smartdns.conf
            chmod 755 package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
        fi
    fi

    if [ -d "package/feeds/luci/luci-app-mosdns" ]; then
        cp -f ../defconfig/etc/config/mosdns package/feeds/luci/luci-app-mosdns/root/etc/config/mosdns

        # copy config
        cp -f ../defconfig/etc/mosdns/config_custom.yaml package/feeds/luci/luci-app-mosdns/root/etc/mosdns/config_custom.yaml
        cp -f ../defconfig/etc/mosdns/update_rules.sh package/feeds/luci/luci-app-mosdns/root/etc/mosdns/update_rules.sh
        chmod 755 package/feeds/luci/luci-app-mosdns/root/etc/mosdns/update_rules.sh

        # download rules
        curl -kL --retry 3 --connect-timeout 3 -o package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/reject-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt
        curl -kL --retry 3 --connect-timeout 3 -o package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/cn-white.txt https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list
        curl -kL --retry 3 --connect-timeout 3 -o package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/Country.mmdb https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb
    fi
    if [ -d "package/luci-app-mosdns" ]; then
        cp -f ../defconfig/etc/config/mosdns package/luci-app-mosdns/root/etc/config/mosdns

        # copy config
        cp -f ../defconfig/etc/mosdns/config_custom.yaml package/luci-app-mosdns/root/etc/mosdns/config_custom.yaml
        cp -f ../defconfig/etc/mosdns/update_rules.sh package/luci-app-mosdns/root/etc/mosdns/update_rules.sh
        chmod 755 package/luci-app-mosdns/root/etc/mosdns/update_rules.sh

        # download rules
        curl -kL --retry 3 --connect-timeout 3 -o package/luci-app-mosdns/root/etc/mosdns/rule/reject-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt
        curl -kL --retry 3 --connect-timeout 3 -o package/luci-app-mosdns/root/etc/mosdns/rule/cn-white.txt https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list
        curl -kL --retry 3 --connect-timeout 3 -o package/luci-app-mosdns/root/etc/mosdns/rule/Country.mmdb https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb
    fi

fi
