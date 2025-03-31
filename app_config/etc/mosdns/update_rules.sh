#!/bin/bash

github_prefix1="https://ghproxy.wegod.cc/"

github_prefix=${github_prefix1}

tmp_dir=$(mktemp -d) || exit 1

# Dwonload reject-list.txt
http_code=$(curl -skL --retry 3 --connect-timeout 3 -w %{http_code} -o ${tmp_dir}/reject-list.txt ${github_prefix}https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt)

if [ $? == 0 -a $http_code == 200 ]; then
    echo "Dwonload reject-list success"
    mv -f ${tmp_dir}/reject-list.txt /etc/mosdns/rule/reject-list.txt
fi

# Dwonload whitelist.list
http_code=$(curl -skL --retry 3 --connect-timeout 3 -w %{http_code} -o ${tmp_dir}/cn-white.txt ${github_prefix}https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/whitelist.list)

if [ $? == 0 -a $http_code == 200 ]; then
    echo "Dwonload cn-white success"
    mv -f ${tmp_dir}/cn-white.txt /etc/mosdns/rule/cn-white.txt
fi

# Dwonload blacklist.list
http_code=$(curl -skL --retry 3 --connect-timeout 3 -w %{http_code} -o ${tmp_dir}/cn-black.txt ${github_prefix}https://raw.githubusercontent.com/alecthw/chnlist/release/mosdns/blacklist.list)

if [ $? == 0 -a $http_code == 200 ]; then
    echo "Dwonload cn-black success"
    mv -f ${tmp_dir}/cn-black.txt /etc/mosdns/rule/cn-black.txt
fi

# Dwonload Country.mmdb
http_code=$(curl -skL --retry 3 --connect-timeout 3 -w %{http_code} -o ${tmp_dir}/Country.mmdb ${github_prefix}https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/Country.mmdb)

if [ $? == 0 -a $http_code == 200 ]; then
    echo "Dwonload mmdb success"
    mv -f ${tmp_dir}/Country.mmdb /etc/mosdns/rule/Country.mmdb
fi

# delete tmp
rm -rf ${tmp_dir}

# restart service
/etc/init.d/mosdns stop
rm -rf /etc/mosdns/cache.dump
/etc/init.d/mosdns start
