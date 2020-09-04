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
- luci-ssl
- luci-app-udpxy
- luci-app-n2n_n2
- openssl-sftp-server
- ip_full
- vxlan

## LEDE x64

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### Additional apps and packages

- KERNEL_PARTSIZE 32
- ROOTFS_PARTSIZE 760
- luci-ssl-openssl
- luci-app-udpxy
- openssl-sftp-server
- snmpd

## LEDE wrt1900acs/newifi d2

Use coolsnowwolf's [code](https://github.com/coolsnowwolf/lede)

### All luci apps

- luci-ssl-openssl

- luci-theme-argon
- luci-theme-freifunk-generic
- luci-theme-material
- luci-theme-netgear

- luci-app-accesscontrol
- luci-app-adbyby-plus
- luci-app-advanced-reboot (only wrt1900acs)
- luci-app-arpbind
- luci-app-autoreboot
- luci-app-cpufreq
- luci-app-ddns
- luci-app-filetransfer
- luci-app-firewall
- luci-app-frpc
- luci-app-minidlna
- luci-app-mwan3
- luci-app-mwan3helper
- luci-app-n2n_v2
- luci-app-nlbwmon
- luci-app-ramfree
- luci-app-samba4
- luci-app-sfe
- luci-app-ssr-plus
- luci-app-udpxy
- luci-app-upnp
- luci-app-vlmcsd
- luci-app-vsftpd
- luci-app-webadmin
- luci-app-wol
- luci-app-xlnetacc
- luci-app-zerotier

### Additional packages

- ipv6helper
- openssh-sftp-server
- tcpdump
- vxlan

## Generate Patch

``` bash
diff -u file file_new > 001-new.patch
```

Edit the `001-new.patch` file, change file name in second line.
