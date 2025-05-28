# MediaTek Filogic 880 common 固件, openwrt 官方源码

这个 Target 当前仅用于 `Mediatek Official autobuild framework` 构建，使用的官方源码是 `mtk_openwrt_feeds` 中指定的 commit 版本，并非最新源码，所有没有定期构建，当上游更新时会同步更新并构建。

参考：<https://gerrit.mediatek.inc/plugins/gitiles/openwrt/feeds/mtk_openwrt_feeds/+/refs/heads/master/autobuild/unified/Readme.md>

## 记录

mtk 脚本里创建 `.config` 的方式

``` bash
STAGING_DIR_HOST=/home/runner/work/openwrt-actions/openwrt-actions/openwrt/staging_dir/host /home/runner/work/openwrt-actions/openwrt-actions/openwrt/scripts/config/aconf -m -o /home/runner/work/openwrt-actions/openwrt-actions/openwrt/.config -k /home/runner/work/openwrt-actions/openwrt-actions/openwrt/Config.in /builder/mtk-openwrt-feeds/autobuild/unified/filogic/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/mt7988_rfb/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/mt7988_rfb/mt7996/24.10/defconfig

STAGING_DIR_HOST=/home/runner/work/openwrt-actions/openwrt-actions/openwrt/staging_dir/host /home/runner/work/openwrt-actions/openwrt-actions/openwrt/scripts/config/aconf -m -M -o /home/runner/work/openwrt-actions/openwrt-actions/openwrt/.ab/filogic-mac80211-mt7988_rfb-mt7996_defconfig -k /home/runner/work/openwrt-actions/openwrt-actions/openwrt/Config.in /builder/mtk-openwrt-feeds/autobuild/unified/filogic/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/mt7988_rfb/24.10/defconfig /builder/mtk-openwrt-feeds/autobuild/unified/filogic/mac80211/mt7988_rfb/mt7996/24.10/defconfig
```
