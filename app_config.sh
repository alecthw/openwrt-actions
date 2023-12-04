#!/bin/bash

# Execute after install feeds as the last script
# patch -> [update & install feeds] -> custom -> config

ROOT_DIR=$(
    cd $(dirname $0)
    pwd
)

source ../lib.sh

target=$1
echo "Execute common app_config.sh ${target}"

target_array=(${target//-/ })
build_source=${target_array[0]}
build_type=${target_array[1]}
build_target=${target_array[2]}
build_arch=${target_array[3]}
echo "source=${build_source}, type=${build_type}, target=${build_target}, arch=${build_arch}"

# copy default config
if [ -z "${APP_CONFIG_DIR}" ]; then
    APP_CONFIG_DIR="app_config"
fi

if [ -d "../$APP_CONFIG_DIR" ]; then
    copy_s ../$APP_CONFIG_DIR/etc/uci-defaults/zzzz-extra-settings package/base-files/files/etc/uci-defaults/zzzz-extra-settings

    if [ -d "package/feeds/packages/ddns-scripts" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/ddns package/feeds/packages/ddns-scripts/files/ddns.config
    fi

    if [ -d "package/feeds/packages/nginx-util" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/nginx package/feeds/packages/nginx-util/files/nginx.config
    fi

    if [ -d "package/feeds/luci/luci-app-adbyby-plus" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/adbyby package/feeds/luci/luci-app-adbyby-plus/root/etc/config/adbyby
    fi

    if [ -d "package/feeds/passwall/luci-app-passwall" ]; then
        # copy_s ../$APP_CONFIG_DIR/etc/config/passwall package/feeds/passwall/luci-app-passwall/root/etc/config/passwall
        copy_s ../$APP_CONFIG_DIR/usr/share/passwall package/feeds/passwall/luci-app-passwall/root/usr/share/passwall
        chmod 755 package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/curl_ping.sh
        chmod 755 package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/test_node.sh

        mkdir package/feeds/passwall/luci-app-passwall/root/usr/share/geodata
        dl_curl https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat package/feeds/passwall/luci-app-passwall/root/usr/share/geodata/geoip.dat
        dl_curl https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat package/feeds/passwall/luci-app-passwall/root/usr/share/geodata/geosite.dat
    fi

    if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
        copy_s ../$APP_CONFIG_DIR/etc/config/smartdns package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
        copy_s ../$APP_CONFIG_DIR/etc/smartdns/custom.conf package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf
        copy_s ../$APP_CONFIG_DIR/etc/smartdns/anti-ad.sh package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
        if [ -f "package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh" ]; then
            dl_curl https://anti-ad.net/anti-ad-for-smartdns.conf package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad-smartdns.conf
            chmod 755 package/feeds/luci/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
        fi
    fi

    if [ -d "package/feeds/luci/luci-app-mosdns" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/mosdns package/feeds/luci/luci-app-mosdns/root/etc/config/mosdns

        # copy config
        copy_s ../$APP_CONFIG_DIR/etc/mosdns/config_custom.yaml package/feeds/luci/luci-app-mosdns/root/etc/mosdns/config_custom.yaml
        copy_s ../$APP_CONFIG_DIR/etc/mosdns/update_rules.sh package/feeds/luci/luci-app-mosdns/root/etc/mosdns/update_rules.sh
        chmod 755 package/feeds/luci/luci-app-mosdns/root/etc/mosdns/update_rules.sh

        # download rules
        dl_curl https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/reject-list.txt
        dl_curl https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/cn-white.txt
        dl_curl https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb package/feeds/luci/luci-app-mosdns/root/etc/mosdns/rule/Country.mmdb
    fi

    if [ -d "package/luci-app-adguardhome" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/AdGuardHome package/luci-app-adguardhome/root/etc/config/AdGuardHome
        copy_s ../$APP_CONFIG_DIR/etc/AdGuardHome package/luci-app-adguardhome/root/etc/AdGuardHome

        # download latest adguardhome core
        dl_curl https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_${build_arch}.tar.gz package/luci-app-adguardhome/root/etc/AdGuardHome.tar.gz
        tar xzf package/luci-app-adguardhome/root/etc/AdGuardHome.tar.gz -C package/luci-app-adguardhome/root/etc/
        rm -rf package/luci-app-adguardhome/root/etc/AdGuardHome.tar.gz
    fi

    if [ -d "package/luci-app-openclash" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/openclash package/luci-app-openclash/root/etc/config/openclash
        # sed -i '/^config dns_servers/,$d' package/luci-app-openclash/root/etc/config/openclash

        # config runtime config file
        copy_s ../$APP_CONFIG_DIR/etc/openclash/config/OpenClash.yaml package/luci-app-openclash/root/etc/openclash/config/OpenClash.yaml

        openclash_arch="${build_arch}"
        case "${build_arch}" in
        amd64)
            openclash_arch="amd64-compatible"
            ;;
        mipsle_softfloat)
            openclash_arch="mipsle-softfloat"
            ;;
        *)
            echo "Same as build_arch: ${build_arch}!"
            ;;
        esac

        # download latest clash meta core
        mkdir -p package/luci-app-openclash/root/etc/openclash/core
        clash_meta_version=$(curl -kLs "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
        echo "clash_meta_version: ${clash_meta_version}"
        # mihomo-linux-amd64-compatible-v1.17.0.gz
        dl_curl https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-${openclash_arch}-${clash_meta_version}.gz package/luci-app-openclash/root/etc/openclash/core/clash_meta.gz

        gzip -f -d package/luci-app-openclash/root/etc/openclash/core/clash_meta.gz
        chmod 755 package/luci-app-openclash/root/etc/openclash/core/clash_meta

        # update geosite
        rm -rf package/luci-app-openclash/root/etc/openclash/GeoSite.dat
        dl_curl https://testingcf.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat package/luci-app-openclash/root/etc/openclash/GeoSite.dat

        # update mmdb
        rm -rf package/luci-app-openclash/root/etc/openclash/Country.mmdb
        dl_curl https://testingcf.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb package/luci-app-openclash/root/etc/openclash/Country.mmdb

        # download rule provider files
        rm -rf package/luci-app-openclash/root/etc/openclash/rule_provider
        dl_svn https://github.com/blackmatrix7/ios_rule_script/trunk/rule/Clash package/luci-app-openclash/root/etc/openclash/rule_provider/rules
        mv -f package/luci-app-openclash/root/etc/openclash/rule_provider/rules/**/*.yaml package/luci-app-openclash/root/etc/openclash/rule_provider
        rm -rf package/luci-app-openclash/root/etc/openclash/rule_provider/rules
        dl_svn https://github.com/alecthw/chnlist/branches/release/Providers/Custom package/luci-app-openclash/root/etc/openclash/rule_provider
    fi

    if [ -d "package/feeds/luci/luci-app-turboacc" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/turboacc package/feeds/luci/luci-app-turboacc/root/etc/config/turboacc
    fi

    if [ -d "package/feeds/packages/n2n" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/n2n package/feeds/packages/n2n/files/n2n.config
    fi

    if [ -d "package/feeds/packages/udpxy" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/udpxy package/feeds/packages/udpxy/files/udpxy.conf
    fi

    if [ -d "package/feeds/luci/luci-app-vlmcsd" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/vlmcsd package/feeds/luci/luci-app-vlmcsd/root/etc/config/vlmcsd
    fi

    if [ -d "package/feeds/packages/zerotier" ]; then
        copy_s ../$APP_CONFIG_DIR/etc/config/zerotier package/feeds/packages/zerotier/files/etc/config/zerotier
        if [ -f "../$APP_CONFIG_DIR/etc/config/zero.tar.gz" ]; then
            tar xzf ../$APP_CONFIG_DIR/etc/config/zero.tar.gz -C package/feeds/packages/zerotier/files/etc/config/
        fi
    fi
fi
