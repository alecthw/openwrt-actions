# OpenWRT 编译

[![build-openwrt](https://github.com/alecthw/openwrt-actions/actions/workflows/build-openwrt.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-openwrt.yml)
[![build-n1](https://github.com/alecthw/openwrt-actions/actions/workflows/build-n1.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-n1.yml)
[![build-private](https://github.com/alecthw/openwrt-actions/actions/workflows/build-private.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-private.yml)

每周五自动构建新版本。

专注制作旁路由精简固件，稳定运行！

默认IP: `192.168.11.4/24`
默认GW: `192.168.11.1`

密码: `没有密码`，其他涉及默认密码的都是`password`

## 详细说明见各个目标子目录

- [lede-common-x86-amd64](user/lede-common-x86-amd64/README.md) 旁路由固件
- [lede-common-r2s-arm64](user/lede-common-r2s-arm64/README.md) 旁路由固件

## 命令行修改IP和掩码

```bash
# 作为旁路路由，IP不建议设置1，防止和主路由冲突！
uci set network.lan.ipaddr='192.168.1.2'
uci set network.lan.netmask='255.255.255.0'
uci commit network
```

## 编译和固件个性化说明

1. 导出`Settings.ini`内容为环境变量
2. 克隆OpenWRT源码
3. 安装`user/common/patches`和`user/[target]/patches`目录下的补丁
4. 更新feeds，Update feeds
5. 复制`user/common/files`和`user/[target]/files`到`[OpenWRT Code Dir]/files`，注意后者覆盖前者
6. 执行脚本`user/common/custom.sh`和`user/[target]/custom.sh`
7. 安装feeds，Install feeds
8. 执行`app_config.sh`脚本，对插件做自定义，包括下载部分插件需要的二进制执行文件，例如`clash`和`AdGuardHome`
9. 开始编译

## 转换工具下载

StarWind V2V Converter

[Download link](https://www.starwindsoftware.com/tmplink/starwindconverter.exe)


## 链接

- [coolsnowwolf lede](https://github.com/coolsnowwolf/lede)
