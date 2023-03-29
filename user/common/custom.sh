#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

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
}

do_official_common() {
    echo ""
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
official)
    echo "do official"
    do_official_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
