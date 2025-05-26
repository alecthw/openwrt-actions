# BPI-R4 common 固件, lede 源码

默认 IP: `192.168.1.1/24`

密码: `没有密码`，其他涉及默认密码的都是 `password`

SD-Card 大小需要大于 8GB，`ROOTFS_PARTSIZE` 设置的是 7168 MiB

## 特性

常规主路由固件，**非旁路由配置**。

### 主要插件应用

详细参考 `[config.diff](config.diff)

- CONFIG_PACKAGE_autocore-arm
- CONFIG_PACKAGE_automount
- CONFIG_PACKAGE_luci-ssl-openssl
- CONFIG_PACKAGE_luci-app-adguardhome
- CONFIG_PACKAGE_luci-app-attendedsysupgrade
- CONFIG_PACKAGE_luci-app-autoreboot
- CONFIG_PACKAGE_luci-app-ddns
- CONFIG_PACKAGE_luci-app-firewall
- CONFIG_PACKAGE_luci-app-frpc
- CONFIG_PACKAGE_luci-app-mosdns
- CONFIG_PACKAGE_luci-app-openclash
- CONFIG_PACKAGE_luci-app-package-manager
- CONFIG_PACKAGE_luci-app-ramfree
- CONFIG_PACKAGE_luci-app-vlmcsd
- CONFIG_PACKAGE_luci-app-wol
- CONFIG_PACKAGE_luci-app-zerotier
- CONFIG_PACKAGE_luci-theme-argon-jerrykuku
- CONFIG_PACKAGE_luci-theme-design

## 默认的 Network Interface

- **WAN:** eth2, lan0
- **LAN:** eth1, lan0, lan1, lan2, lan3
- **2.4G wireless:** ra0/ra1
- **5G wifi6 wireless:** rai0
- **6G wifi7 wireless:** rax0

## 8GB 内存版本需更新 bl2

[下载地址](https://github.com/frank-w/u-boot/releases)

``` txt
bpi-r4_emmc_8GB_bl2.img
bpi-r4_sdmmc_8GB_bl2.img
bpi-r4_spim-nand_8GB_bl2.img
```

### SD Card 更新 bl2

通过 SD Card 启动后，上传 `bpi-r4_sdmmc_8GB_bl2.img`，执行

```bash
dd if=bpi-r4_sdmmc_8GB_bl2.img of=/dev/mmcblk0p1
```

### Nand 更新 bl2

**以下仅为记录，尝试数次均未成功，报错 `System halt!`，有知道怎么刷的大佬求指点。**

```bash
# 查看分区与mtd编号
cat /proc/mtd

# 加载内核模块
insmod mtd-rw i_want_a_brick=1

# 方法一：通过 nandwrite
nandwrite -p /dev/mtd0 bpi-r4_spim-nand_8GB_bl2.img

# 方法二： 通过 mtd
mtd write bpi-r4_spim-nand_8GB_bl2.img bl2
```

### EMMC 更新 bl2

通过 Nand 或 EMMC 启动后，上传 `bpi-r4_emmc_8GB_bl2.img`，执行

```bash
echo 0 > /sys/block/mmcblk0boot0/force_ro
dd if=bpi-r4_emmc_8GB_bl2.img of=/dev/mmcblk0boot0
mmc bootpart enable 1 1 /dev/mmcblk0 # 这个命令好像不是必须的，好像刷固件才需要
```

附下官方文档里刷固件的命令：

```bash
echo 0 > /sys/block/mmcblk0boot0/force_ro
dd if=bl2_emmc-r4.img of=/dev/mmcblk0boot0
dd if=mtk-bpi-r4-EMMC-20231030.img of=/dev/mmcblk0
mmc bootpart enable 1 1 /dev/mmcblk0
```

### mtd 刷 bl2

我试了几次好像不起作用，哪位大佬研究下告诉我(*^_^*)

编译时需要增加 `CONFIG_PACKAGE_kmod-mtd-rw=y`，否则 `mtd` 命令无法写入。

```bash
cat /proc/mtd
insmod mtd-rw i_want_a_brick=1
mtd erase bl2
mtd write bpi-r4_spim-nand_8GB_bl2.img bl2
mtd verify bpi-r4_spim-nand_8GB_bl2.img bl2
```

## 链接

### Official

- [BananaPi BPI-R4 Docs](https://docs.banana-pi.org/en/BPI-R4/BananaPi_BPI-R4)
- [GettingStarted BPI-R4](https://docs.banana-pi.org/en/BPI-R4/GettingStarted_BPI-R4)
- [Official firmware](https://github.com/BPI-SINOVOIP/BPI-R4-MT76-OPENWRT-V21.02)
- [OpenWrt Official Help for BPI-R4](https://openwrt.org/inbox/toh/sinovoip/bananapi_bpi-r4)
- [mtk-openwrt-feeds](https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/)
- [U-boot for BPI-R2/R64/R2Pro/R3/R4](https://github.com/frank-w/u-boot)

### Community

- [Banana Pi BPI-R4 OpenWRT Auto Build](https://github.com/chenglong-do/bpi-r4-openwrt-main)
- [padavanonly firmware for mt798x](https://github.com/padavanonly/immortalwrt-mt798x-24.10)
