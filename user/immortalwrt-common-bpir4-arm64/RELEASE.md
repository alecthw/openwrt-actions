# Important

In order to circumvent the 44MB limit of initramfs, this firmware does not enable initramfs. So it can not boot recovery system.

Error msg:

``` txt
WARNING: Image file /home/alecthw/openwrt-actions/immortalwrt_common/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_filogic/tmp/immortalwrt-mediatek-filogic-bananapi_bpi-r4-sdcard.img.gz is too big: 50003968 > 46137344
```

See code: [target/linux/mediatek/image/filogic.mk](https://github.com/immortalwrt/immortalwrt/blob/1d09f53f9da21135ab803ab515fc0b114a2c0cf8/target/linux/mediatek/image/filogic.mk#L489)

If you need boot recovery system, please use the [ImmortalWrt Official Firmware](https://downloads.immortalwrt.org/releases/24.10-SNAPSHOT/targets/mediatek/filogic/).

## Default

- Default IP: `192.168.11.1/24`
- Default Password: `no password`

Other apps default password is usually `password`

The SD-Card size should to be larger than 8GB. The `ROOTFS_PARTSIZE` is set to 7168 MiB.

### Network Interface

- **WAN:** eth2, lan0
- **LAN:** eth1, lan0, lan1, lan2, lan3
- **2.4G wireless:** ra0/ra1
- **5G wifi6 wireless:** rai0
- **6G wifi7 wireless:** rax0
