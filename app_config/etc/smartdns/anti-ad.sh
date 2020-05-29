#!/bin/sh

tmp_dir=$(mktemp -d)

#https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf
curl -skL --retry 3 --connect-timeout 3 -o $tmp_dir/anti-ad-smartdns.conf https://anti-ad.net/anti-ad-for-smartdns.conf

if [ $? == 0 ]; then
    mv -f $tmp_dir/anti-ad-smartdns.conf /etc/smartdns/anti-ad-smartdns.conf
    /etc/init.d/smartdns restart
fi

rm -rf $tmp_dir
