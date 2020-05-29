#!/bin/bash

github_prefix1="https://ghproxy.net/"
github_prefix2="https://ghproxy.com/"
github_prefix3="https://gitclone.com/"
github_prefix4="https://hub.fgit.gq/"
github_prefix5="https://hub.fgit.ml/"
github_prefix6="https://hub.yzuu.cf/"

github_prefix=${github_prefix1}

tmp_dir=$(mktemp -d) || exit 1

# Dwonload reject-list.txt
curl -skL --retry 3 --connect-timeout 3 -o ${tmp_dir}/reject-list.txt ${github_prefix}https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt

if [ $? == 0 ]; then
    echo "Dwonload reject-list success"
    mv -f ${tmp_dir}/reject-list.txt /etc/mosdns/rule/reject-list.txt
fi

# Dwonload whitelist.list
curl -skL --retry 3 --connect-timeout 3 -o ${tmp_dir}/cn-white.txt ${github_prefix}https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list

if [ $? == 0 ]; then
    echo "Dwonload cn-white success"
    mv -f ${tmp_dir}/cn-white.txt /etc/mosdns/rule/cn-white.txt
fi

# Dwonload Country.mmdb
curl -skL --retry 3 --connect-timeout 3 -o ${tmp_dir}/Country.mmdb ${github_prefix}https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb

if [ $? == 0 ]; then
    echo "Dwonload mmdb success"
    mv -f ${tmp_dir}/Country.mmdb /etc/mosdns/rule/Country.mmdb
fi

# delete tmp
rm -rf ${tmp_dir}

# restart service
/etc/init.d/mosdns stop
rm -rf /etc/mosdns/cache.dump
/etc/init.d/mosdns start
