# OpenWRT Actions

Build OpenWRT using github actions!

[![router](https://github.com/alecthw/openwrt-actions/actions/workflows/router.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/router.yml)
[![device](https://github.com/alecthw/openwrt-actions/actions/workflows/device.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/device.yml)

Default IP: `192.168.11.1/24`, No password.

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

## Images Config

- ext4
- squashfs
- VMWare
- GZip
- Kernel partition size: 32MB
- Root filesystem partition 760MB

## LEDE

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### Packages

Refer to:

- x86_64: [config.diff](user/lede-x64/config.diff)
- r2s: [config.diff](user/lede-r2s/config.diff)
- wrt1900acs: [config.diff](user/lede-wrt1900acs/config.diff)
- newifi d2: [config.diff](user/lede-newifi_d2/config.diff)

## Lienol x64

Use Lienol's [code](https://github.com/Lienol/openwrt)

## StarWind V2V Converter

[Download link](https://www.starwindsoftware.com/tmplink/starwindconverter.exe)

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
