#!/bin/sh

rm -rf /tmp/anti-ad-smartdns.conf

#https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf
curl -skL --retry 3 --connect-timeout 3 -o /tmp/anti-ad-smartdns.conf https://anti-ad.net/anti-ad-for-smartdns.conf

if [ $? == 0 ];then
    cp -af /tmp/anti-ad-smartdns.conf /etc/smartdns/anti-ad-smartdns.conf
    rm -rf /tmp/anti-ad-smartdns.conf
    /etc/init.d/smartdns restart
fi
