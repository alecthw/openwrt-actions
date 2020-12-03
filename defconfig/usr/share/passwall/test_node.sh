#!/bin/sh

CONFIG=passwall
FORMAT="%-35s %-12s %-12s %-12s\n"

# Title
echo "测试前请先手动更新订阅，并将dnsmasq和smartdns缓存设置成0"
echo "测试过程根据节点数量和延迟大小持续数秒至数分钟不等"
printf "${FORMAT}" Node Google Github Pornhub

lanip=$(uci get network.lan.ipaddr)

error() {
    local msg=$1
    local exit_code=$2

    echo "Error: ${msg}" >&2

    if [ -n "${exit_code}" ]; then
        exit ${exit_code}
    fi
}

config_n_get() {
    local ret=$(uci -q get "${CONFIG}.${1}.${2}" 2>/dev/null)
    echo "${ret:=$3}"
}

test_delay() {
    local time_starttransfer=0 # 在发出请求之后，Web服务器返回数据的第一个字节所用的时间

    # prepare test
    for i in $(seq 1 1); do
        local result_tmp=$(curl -o /dev/null --connect-timeout 2 -k -s -w "%{http_code} %{time_starttransfer} " https://$1)
    done

    # test
    local count=0
    for i in $(seq 1 3); do
        local result=$(curl -o /dev/null --connect-timeout 2 -k -s -w "%{http_code} %{time_starttransfer} " https://$1)

        local sta=$(echo ${result} | awk '{print $1}')
        local t_s=$(echo ${result} | awk '{print $2}')

        if [ ${sta} == "000" ]; then
            continue
        fi

        count=$(echo "$count" | awk '{print $1+1}')

        local t_s_ms=$(echo "${t_s}" | awk '{printf ("%.3f\n",$1*1000)}')
        time_starttransfer=$(echo "${time_starttransfer} ${t_s_ms}" | awk '{printf ("%.3f\n",$1+$2)}')
    done

    local ave_s="-"
    if [ ${count} -gt 0 ]; then
        ave_s=$(echo "${time_starttransfer} ${count}" | awk '{printf ("%.3f\n",$1/$2)}')
    fi

    echo ${ave_s}
}

do_passwall() {
    if [ ! -f "/etc/config/passwall" ]; then
        error "Passwall not installed! Please install first!" 1
    fi

    # update rule and subscribe
    #lua /usr/share/passwall/subscribe.lua start log >/dev/null 2>&1
    lua /usr/share/passwall/rule_update.lua log >/dev/null 2>&1

    # backup
    cp -af /etc/config/passwall /etc/config/passwall_bak

    # change local proxy mode
    uci set passwall.@global[0].enabled='1'
    uci set passwall.@global[0].localhost_tcp_proxy_mode='chnroute'
    uci set passwall.@global[0].localhost_udp_proxy_mode='chnroute'
    # disable auto switch
    uci set passwall.@auto_switch[0].enable='0'
    uci commit passwall

    local nodes=$(uci show ${CONFIG} | grep "=nodes" | awk -F '.' '{print $2}' | awk -F '=' '{print $1}')
    for node in ${nodes}; do
        local address=$(config_n_get ${node} address)
        local name=$(config_n_get ${node} remarks)

        # skip shunt and local like haproxy
        if [ -z "${address}" ] || [ "${address}" == "${lanip}" ] || [ "${address}" == "127.0.0.1" ]; then
            continue
        fi

        if [ -n "${filter}" ] && [ -z "$(echo ${address} | grep "${filter}")" ]; then
            continue
        fi

        uci set passwall.@global[0].tcp_node1=${node}
        uci commit passwall

        /etc/init.d/passwall restart >/dev/null 2>&1
        sleep 1

        local delay_google=$(test_delay www.google.com)
        local delay_github=$(test_delay github.com)
        local delay_pornhub=$(test_delay www.pornhub.com)

        printf "${FORMAT}" "${name}" ${delay_google} ${delay_github} ${delay_pornhub}
    done

    # resume
    mv -f /etc/config/passwall_bak /etc/config/passwall
    /etc/init.d/passwall restart >/dev/null 2>&1
}

filter=""
while [ -n "$*" ]; do
    arg=$1
    shift
    case "${arg}" in
    --filter | -f)
        [ -n "$1" ] || error "Option --filter|-t requires an argument" 2
        filter=$1
        shift
        ;;
    esac
done

do_passwall
