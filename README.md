# OpenWRT Actions

Build OpenWRT using github actions!

![Badge](https://github.com/alecthw/openwrt-actions/workflows/Openwrt-AutoBuild/badge.svg)

Default IP: `192.168.11.1/24`, no password.

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
- luci-app-tcpdump
- luci-app-udpxy
- luci-theme-argon-jerrykuku
- luci-theme-freifunk-generic
- luci-theme-material
- luci-theme-netgear
- openssl-sftp-server
- snmpd
- tcpdump
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

## Mini Version

It's a very lite img include passwall. It's suitable for bypass router using.

### Apps and packages

- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- dnsmasq-full
- ipv6helper
- kmod-vmxnet3
- default-settings
- luci
- luci-ssl-openssl
- luci-compat
- luci-app-adbyby-plus
- luci-app-n2n_n2
- luci-app-passwall
- luci-app-sfe
- luci-app-smartdns
- luci-app-tcpdump
- luci-app-udpxy
- luci-app-vlmcsd
- luci-theme-argon-jerrykuku
- luci-theme-material
- luci-proto-bonding
- luci-lib-ipkg
- wget
- openssl-sftp-server
- snmpd
- open-vm-tools

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
