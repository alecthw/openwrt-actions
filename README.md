# OpenWRT Actions

Build OpenWRT using github actions!

![Badge](https://github.com/alecthw/openwrt-actions/workflows/Openwrt-AutoBuild/badge.svg)

Default IP: `192.168.11.1/24`, no password.

## Add two tools for passwall

1. /usr/share/passwall/curl_ping.sh
    Using curl to test https delay. A soft link has been created for this shell script.

    ```bash
    root@OpenWrt:~# curl_ping www.google.com
    Times       status       connect       starttransfer       total
    1           200          4.651         178.532             181.278
    2           200          2.860         177.044             180.054
    3           200          2.784         176.976             181.326
    4           200          3.152         182.934             187.729
    5           200          2.937         171.059             175.626
    6           200          4.042         182.357             185.145
    7           200          3.187         189.514             194.292
    8           200          2.773         179.611             184.059
    9           200          3.328         184.851             187.892
    10          200          2.823         173.144             177.637
    Average                  3.254         179.602             183.504
    ```

2. /usr/share/passwall/test_node.sh
    Using curl to test each node delay for passwall. It takes backup for `/etc/config/passwall` first. After test, your config will be resumed.
    You can Use `--filter | -f` option to filter nodes whose url include this param.

    ```bash
    root@OpenWrt:~# /usr/share/passwall/test_node.sh -f hk
    测试前请先手动更新订阅，测试过程根据节点数量和延迟大小持续数秒至数分钟不等
    Node                                Google       Github       Netflix
    台湾1                                232.009      338.637      846.771
    台湾2                                267.508      323.721      1809.887
    ```

## Img Config

- Disable ext4 img
- GZip images
- VMWare images

## Lienol x64

Use Lienol's [code](https://github.com/Lienol/openwrt) dev-master branch

Copy config from [hyird's Actions (Branch 1907)](https://github.com/hyird/openwrt-actions) and [Lienol's Actions (Branch main)](https://github.com/Lienol/openwrt-actions).
Compared with the config, the changes are as follows.

### Additional packages

- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- ipv6helper
- luci-ssl-openssl
- luci-app-jd-dailybonus
- luci-app-n2n_n2
- luci-app-passwall
- luci-app-serverchan
- luci-app-udpxy
- luci-theme-argon-jerrykuku
- luci-theme-material
- openssl-sftp-server
- open-vm-tools

## LEDE x64

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

Compared with the lean's default config, the changes are as follows.

### Additional packages

- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- ipv6helper
- luci-ssl-openssl
- luci-app-jd-dailybonus
- luci-app-n2n_n2
- luci-app-passwall
- luci-app-serverchan
- luci-app-smartdns
- luci-app-ssr-plus
- luci-app-tcpdump
- luci-app-udpxy
- luci-theme-argon-jerrykuku
- luci-theme-material
- luci-theme-netgear
- openssl-sftp-server
- snmpd
- open-vm-tools

## LEDE wrt1900acs/newifi d2

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### Extra packages

- ipv6helper
- automount
- autosamba

### Collections

- luci-ssl-openssl

### Apps

- luci-app-adbyby-plus
- luci-app-advanced-reboot (only wrt1900acs)
- luci-app-autoreboot
- luci-app-cpufreq (only wrt1900acs)
- luci-app-ddns
- luci-app-filetransfer
- luci-app-firewall
- luci-app-flowoffload (only newifi d2)
- luci-app-frpc
- luci-app-minidlna
- luci-app-mtwifi (only newifi d2)
- luci-app-mwan3
- luci-app-mwan3helper
- luci-app-n2n_v2
- luci-app-ramfree
- luci-app-samba
- luci-app-sfe (only wrt1900acs)
- luci-app-ssr-plus (V2ray_plugin, V2ray, Trojan, Redsocks2, ShadowsocksR_Server)
- luci-app-syncdial
- luci-app-tcpdump
- luci-app-udpxy
- luci-app-upnp
- luci-app-vlmcsd
- luci-app-vsftpd
- luci-app-wol
- luci-app-xlnetacc

### Themes

- luci-theme-argon-jerrykuku
- luci-theme-material

### Protocols

- luci-proto-bonding

### Other packages

- curl
- openssh-sftp-server
- snmpd

## StarWind V2V Converter

https://www.starwindsoftware.com/tmplink/starwindconverter.exe

## Generate Patch

``` bash
diff -u file file_new > 001-new.patch
```

Edit the `001-new.patch` file, change file name in second line.

## Script for local build

Init init environment, install dependencies

``` bash
bash localbuild.sh e
```

Compile

``` bash
bash localbuild.sh p -t lienol-master-x64   # Clone/Update code, Update feeds, apply custom settings, make defconfig
bash localbuild.sh c -t lienol-master-x64   # make download, make
```
