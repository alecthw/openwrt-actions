#!/bin/bash

# Execute after install feeds as the last script
# patch -> [update & install feeds] -> custom -> config

echo "Current dir: $(pwd), Script: $0"

if [ -z "${GITHUB_WORKSPACE}" ]; then
    echo "GITHUB_WORKSPACE not set"
    GITHUB_WORKSPACE=$(
        cd $(dirname $0)
        pwd
    )
    export GITHUB_WORKSPACE
fi

source $GITHUB_WORKSPACE/lib.sh

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

# Priority: package dir > feeds dir
if [ -d "$GITHUB_WORKSPACE/$APP_CONFIG_DIR" ]; then
    copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/uci-defaults/zzzz-extra-settings package/base-files/files/etc/uci-defaults/zzzz-extra-settings

    if [ -d "package/feeds/luci/luci-app-autoreboot" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/autoreboot package/feeds/luci/luci-app-autoreboot/root/etc/config/autoreboot
    fi

    if [ -d "package/feeds/packages/ddns-scripts" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/ddns package/feeds/packages/ddns-scripts/files/etc/config/ddns
    fi

    if [ -d "package/feeds/packages/nginx-util" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/nginx package/feeds/packages/nginx-util/files/nginx.config
    fi

    LUCI_APP_SMARTDNS_DIR=""
    if [ -d "package/luci-app-smartdns" ]; then
        LUCI_APP_SMARTDNS_DIR="package/luci-app-smartdns"
    elif [ -d "package/feeds/luci/luci-app-smartdns" ]; then
        LUCI_APP_SMARTDNS_DIR="package/feeds/luci/luci-app-smartdns"
    fi
    if [ -n "$LUCI_APP_SMARTDNS_DIR" ]; then
        mkdir -p $LUCI_APP_SMARTDNS_DIR/root/etc/config
        mkdir -p $LUCI_APP_SMARTDNS_DIR/root/etc/smartdns
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/smartdns $LUCI_APP_SMARTDNS_DIR/root/etc/config/smartdns
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/smartdns/custom.conf $LUCI_APP_SMARTDNS_DIR/root/etc/smartdns/custom.conf
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/smartdns/anti-ad.sh $LUCI_APP_SMARTDNS_DIR/root/etc/smartdns/anti-ad.sh
        if [ -f "$LUCI_APP_SMARTDNS_DIR/root/etc/smartdns/anti-ad.sh" ]; then
            dl_curl https://anti-ad.net/anti-ad-for-smartdns.conf $LUCI_APP_SMARTDNS_DIR/root/etc/smartdns/anti-ad-smartdns.conf
            chmod 755 $LUCI_APP_SMARTDNS_DIR/root/etc/smartdns/anti-ad.sh
        fi
    fi

    LUCI_APP_MOSDNS_DIR=""
    if [ -d "package/luci-app-mosdns" ]; then
        LUCI_APP_MOSDNS_DIR="package/luci-app-mosdns"
    elif [ -d "package/feeds/luci/luci-app-mosdns" ]; then
        LUCI_APP_MOSDNS_DIR="package/feeds/luci/luci-app-mosdns"
    fi
    if [ -n "$LUCI_APP_MOSDNS_DIR" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/mosdns $LUCI_APP_MOSDNS_DIR/root/etc/config/mosdns

        # copy config
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/mosdns/config_custom.yaml $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/config_custom.yaml
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/mosdns/update_rules.sh $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/update_rules.sh
        chmod 755 $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/update_rules.sh

        # download rules
        dl_curl https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/rule/reject-list.txt
        dl_curl https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/rule/cn-white.txt
        dl_curl https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb $LUCI_APP_MOSDNS_DIR/root/etc/mosdns/rule/Country.mmdb
    fi

    LUCI_APP_ADGUARDHOME_DIR=""
    if [ -d "package/luci-app-adguardhome" ]; then
        LUCI_APP_ADGUARDHOME_DIR="package/luci-app-adguardhome"
    elif [ -d "package/feeds/luci/luci-app-adguardhome" ]; then
        LUCI_APP_ADGUARDHOME_DIR="package/feeds/luci/luci-app-adguardhome"
    fi
    if [ -n "$LUCI_APP_ADGUARDHOME_DIR" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/AdGuardHome $LUCI_APP_ADGUARDHOME_DIR/root/etc/config/AdGuardHome
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/AdGuardHome $LUCI_APP_ADGUARDHOME_DIR/root/etc/AdGuardHome

        # download latest adguardhome core
        dl_curl https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_${build_arch}.tar.gz $LUCI_APP_ADGUARDHOME_DIR/root/etc/AdGuardHome.tar.gz
        tar xzf $LUCI_APP_ADGUARDHOME_DIR/root/etc/AdGuardHome.tar.gz -C $LUCI_APP_ADGUARDHOME_DIR/root/etc/
        rm -rf $LUCI_APP_ADGUARDHOME_DIR/root/etc/AdGuardHome.tar.gz
    fi

    LUCI_APP_OPENCLASH_DIR=""
    if [ -d "package/luci-app-openclash" ]; then
        LUCI_APP_OPENCLASH_DIR="package/luci-app-openclash"
    elif [ -d "package/feeds/luci/luci-app-openclash" ]; then
        LUCI_APP_OPENCLASH_DIR="package/feeds/luci/luci-app-openclash"
    fi
    if [ -n "$LUCI_APP_OPENCLASH_DIR" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/openclash $LUCI_APP_OPENCLASH_DIR/root/etc/config/openclash
        # sed -i '/^config dns_servers/,$d' $LUCI_APP_OPENCLASH_DIR/root/etc/config/openclash

        # config runtime config file
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/openclash/config $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/config

        openclash_arch="${build_arch}"
        case "${build_arch}" in
        mipsle_softfloat)
            openclash_arch="mipsle-softfloat"
            ;;
        *)
            echo "Same as build_arch: ${build_arch}!"
            ;;
        esac

        # download latest clash meta core
        mkdir -p $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/core
        clash_meta_version=$(curl -kLs "https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
        echo "clash_meta_version: ${clash_meta_version}"
        # mihomo-linux-amd64-compatible-v1.17.0.gz
        dl_curl https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-${openclash_arch}-${clash_meta_version}.gz $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/core/clash_meta.gz

        gzip -f -d $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/core/clash_meta.gz
        chmod 755 $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/core/clash_meta

        # update geosite
        rm -rf $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/GeoSite.dat
        dl_curl https://testingcf.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/GeoSite.dat

        # update mmdb
        rm -rf $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/Country.mmdb
        dl_curl https://testingcf.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/Country.mmdb

        # download rule provider files
        rm -rf $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider
        dl_git_sub https://github.com/blackmatrix7/ios_rule_script $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider/rules rule/Clash master
        mv -f $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider/rules/**/*.yaml $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider
        rm -rf $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider/rules
        dl_git_sub https://github.com/alecthw/chnlist $LUCI_APP_OPENCLASH_DIR/root/etc/openclash/rule_provider Providers/Custom release
    fi

    if [ -d "package/feeds/luci/luci-app-turboacc" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/turboacc package/feeds/luci/luci-app-turboacc/root/etc/config/turboacc
    fi

    if [ -d "package/feeds/packages/udpxy" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/udpxy package/feeds/packages/udpxy/files/udpxy.conf
    fi

    if [ -d "package/feeds/luci/luci-app-vlmcsd" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/vlmcsd package/feeds/luci/luci-app-vlmcsd/root/etc/config/vlmcsd
    fi

    ZEROTIER_DIR=""
    if [ -d "package/zerotier" ]; then
        ZEROTIER_DIR="package/zerotier"
    elif [ -d "package/feeds/packages/zerotier" ]; then
        ZEROTIER_DIR="package/feeds/packages/zerotier"
    fi
    if [ -n "$ZEROTIER_DIR" ]; then
        copy_s $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/zerotier $ZEROTIER_DIR/files/etc/config/zerotier
        if [ -f "$GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/zero.tar.gz" ]; then
            tar xzf $GITHUB_WORKSPACE/$APP_CONFIG_DIR/etc/config/zero.tar.gz -C $ZEROTIER_DIR/files/etc/config/
        fi
    fi
fi
