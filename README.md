# OpenWRT Actions

Build OpenWRT using github actions!

![X64-LEDE](https://github.com/alecthw/openwrt-actions/workflows/Openwrt-AutoBuild/badge.svg)

## LEDE x64

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### Add additional apps

- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- luci-ssl-openssl
- luci-app-udpxy
- openssl-sftp-server
- snmpd

## Lienol x64

Use Lienol's [code](https://github.com/Lienol/openwrt) dev-master branch

Copy action from [hyird's Actions](https://github.com/hyird/openwrt-actions) and [Lienol's Actions](https://github.com/Lienol/openwrt-actions)

### Add additional apps

- Default_IP 192.168.11.1/24
- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- luci-ssl
- luci-app-udpxy
- openssl-sftp-server
