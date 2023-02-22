#!/bin/bash

# Execute after install feeds

target=$1
echo "Execute common custom.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "source=${source}"

do_common() {
    # modify passwall subscribe.lua
    subscribe_script="package/feeds/passwall/luci-app-passwall/root/usr/share/passwall/subscribe.lua"
    if [ -f "$subscribe_script" ]; then
        sed -i '/第一优先级/i\		-- 自定义优先级 订阅 + 类型 + 备注' $subscribe_script
        sed -i '/第一优先级/i\		if not server then' $subscribe_script
        sed -i '/第一优先级/i\			for index, node in pairs(nodes) do' $subscribe_script
        sed -i '/第一优先级/i\				if config.currentNode.add_from and config.currentNode.type and config.currentNode.remarks then' $subscribe_script
        sed -i '/第一优先级/i\					if node.add_from and node.type and node.remarks then' $subscribe_script
        sed -i '/第一优先级/i\						if node.add_from == config.currentNode.add_from and node.type == config.currentNode.type and node.remarks == config.currentNode.remarks then' $subscribe_script
        sed -i '/第一优先级/i\							if config.log == nil or config.log == true then' $subscribe_script
        sed -i "/第一优先级/i\								log('更新【' .. config.remarks .. '】自定义匹配节点：' .. node.remarks)" $subscribe_script
        sed -i '/第一优先级/i\							end' $subscribe_script
        sed -i '/第一优先级/i\							server = node[".name"]' $subscribe_script
        sed -i '/第一优先级/i\							break' $subscribe_script
        sed -i '/第一优先级/i\						end' $subscribe_script
        sed -i '/第一优先级/i\					end' $subscribe_script
        sed -i '/第一优先级/i\				end' $subscribe_script
        sed -i '/第一优先级/i\			end' $subscribe_script
        sed -i '/第一优先级/i\		end' $subscribe_script

        sed -i 's/log = false/log = true/g' $subscribe_script
    fi

    # copy default config
    if [ -d "../defconfig" ]; then
        cp -f ../defconfig/zzz-extra-settings package/base-files/files/etc/uci-defaults/zzzz-extra-settings

        if [ "${target}" != "lede-openclash-x64" ]; then
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
            cp -f ../defconfig/etc/config/passwall package/feeds/passwall/luci-app-passwall/root/etc/config/passwall
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
            if [ "${target}" != "lede-openclash-x64" ]; then
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
        if [ -d "package/luci-app-smartdns" ]; then
            mkdir -p package/luci-app-smartdns/root/etc/config
            mkdir -p package/luci-app-smartdns/root/etc/smartdns
            if [ "${target}" != "lede-openclash-x64" ]; then
                cp -f ../defconfig/etc/config/smartdns package/luci-app-smartdns/root/etc/config/smartdns
                cp -rf ../defconfig/etc/smartdns/custom.conf package/luci-app-smartdns/root/etc/smartdns/custom.conf
            else
                # special for openclash
                cp -f ../defconfig/etc/config/smartdns_openclash package/luci-app-smartdns/root/etc/config/smartdns
                cp -rf ../defconfig/etc/smartdns/custom_openclash.conf package/luci-app-smartdns/root/etc/smartdns/custom.conf
            fi
            cp -rf ../defconfig/etc/smartdns/anti-ad.sh package/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
            if [ -f "package/luci-app-smartdns/root/etc/smartdns/anti-ad.sh" ]; then
                curl -kL --retry 3 --connect-timeout 3 -o package/luci-app-smartdns/root/etc/smartdns/anti-ad-smartdns.conf https://anti-ad.net/anti-ad-for-smartdns.conf
                chmod 755 package/luci-app-smartdns/root/etc/smartdns/anti-ad.sh
            fi
        fi

        # if [ -d "package/luci-app-openclash" ]; then
            # cp -f ../defconfig/etc/config/openclash package/luci-app-openclash/root/etc/config/openclash
            # sed -i '/^config dns_servers/,$d' package/luci-app-openclash/root/etc/config/openclash
        # fi
    fi
}

do_lienol_common() {
    # delete 53 redirect
    sed -i '/REDIRECT --to-ports 53/d' package/default-settings/files/zzz-default-settings
}

do_lede_common() {
    # delete default password
    sed -i "/shadow/d" package/lean/default-settings/files/zzz-default-settings
    # delete 53 redirect
    sed -i '/REDIRECT --to-ports 53/d' package/lean/default-settings/files/zzz-default-settings
}

# excute begin
do_common

case "${source}" in
lienol)
    echo "do lienol"
    do_lienol_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
