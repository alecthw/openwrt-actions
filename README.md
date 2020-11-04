# OpenWRT Actions

Build OpenWRT using github actions!

![X64-LEDE](https://github.com/alecthw/openwrt-actions/workflows/Openwrt-AutoBuild/badge.svg)

## Lienol x64

Use Lienol's [code](https://github.com/Lienol/openwrt) dev-master branch

Copy action from [hyird's Actions](https://github.com/hyird/openwrt-actions) and [Lienol's Actions](https://github.com/Lienol/openwrt-actions)

### Additional apps and packages

- Default_IP 192.168.11.1/24
- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- ipv6helper
- luci-ssl-openssl
- luci-app-jd-dailybonus
- luci-app-n2n_n2
- luci-app-serverchan
- luci-app-udpxy
- luci-theme-material
- openssl-sftp-server
- open-vm-tools

## LEDE x64

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### Additional apps and packages

- Default_IP 192.168.11.1/24
- GZip images
- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- ipv6helper
- luci-ssl-openssl
- luci-app-jd-dailybonus
- luci-app-n2n_n2
- luci-app-passwall
- luci-app-serverchan
- luci-app-smartdns
- luci-app-udpxy
- luci-theme-argon
- luci-theme-freifunk-generic
- luci-theme-material
- luci-theme-netgear
- openssl-sftp-server
- snmpd
- tcpdump
- open-vm-tools

## LEDE wrt1900acs/newifi d2

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### All luci

#### Collections

- luci-ssl-openssl

#### Apps

- luci-app-accesscontrol
- luci-app-adbyby-plus
- luci-app-advanced-reboot (only wrt1900acs)
- luci-app-arpbind
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
- luci-app-nlbwmon
- luci-app-ramfree
- luci-app-samba
- luci-app-sfe (only wrt1900acs)
- luci-app-ssr-plus
- luci-app-syncdial
- luci-app-udpxy
- luci-app-upnp
- luci-app-vlmcsd
- luci-app-vsftpd
- luci-app-webadmin
- luci-app-wol
- luci-app-xlnetacc
- luci-app-zerotier

#### Themes

- luci-theme-argon
- luci-theme-freifunk-generic
- luci-theme-material
- luci-theme-netgear

#### Additional packages

- ipv6helper
- automount
- autosamba
- curl
- openssh-sftp-server
- snmpd
- tcpdump-mini

## Official x64

Use the [code](https://github.com/alecthw/openwrt) which fork from [official's code](https://github.com/openwrt/openwrt)

It's a very lite img. It's suitable for bypass router using.

### Apps and packages

- Default_IP 192.168.11.1/24
- Disable ext4 img
- VMware img
- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- dnsmasq-full
- ipv6helper
- kmod-vmxnet3
- luci
- luci-ssl-openssl
- luci-compat
- luci-app-adbyby-plus
- luci-app-filetransfer
- luci-app-n2n_n2
<!-- - luci-app-openclash -->
- luci-app-passwall
- luci-app-smartdns
<!-- - luci-app-ssr-plus -->
- luci-app-tcpdump
- luci-app-udpxy
- luci-app-vlmcsd
- luci-theme-material
- luci-proto-bonding
- luci-proto-vxlan
- luci-lib-ipkg
- default-settings
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
