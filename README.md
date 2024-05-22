# OpenWRT 编译

[![build-openwrt](https://github.com/alecthw/openwrt-actions/actions/workflows/build-openwrt.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-openwrt.yml)
[![build-n1](https://github.com/alecthw/openwrt-actions/actions/workflows/build-n1.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-n1.yml)
[![build-private](https://github.com/alecthw/openwrt-actions/actions/workflows/build-private.yml/badge.svg)](https://github.com/alecthw/openwrt-actions/actions/workflows/build-private.yml)

每周五自动构建新版本。

专注制作旁路由精简固件，稳定运行！

默认 IP: `192.168.11.4/24`
默认 GW: `192.168.11.1`

密码: `没有密码`，其他涉及默认密码的都是 `password`

## 详细说明见各个目标子目录

分为旁路由固件和硬件路由固件。需要其他固件可以提 [Wiki](https://github.com/alecthw/openwrt-actions/wiki)。

注意：旁路由固件默认未开启 DHCP！！！

### 旁路由固件

重点是 AdGuardHome 、 mosdns 和 openclash （或 ssrp ）的搭配，详细介绍见子目录下的 README。更多信息可以参考[这篇文章](https://alecthw.github.io/p/2023/11/fuck-gfw/)。

- [lede-common-n1-arm64](user/lede-common-n1-arm64/README.md)
- [lede-common-r2s-arm64](user/lede-common-r2s-arm64/README.md)
- [lede-common-x86-amd64](user/lede-common-x86-amd64/README.md)
- [lede-openclash-x86-amd64](user/lede-openclash-x86-amd64/README.md)

#### 特别说明

##### 1. DHCP 服务器

一般情况下建议禁用旁路由 DHCP 服务器，在主路由配置 DHCP 服务器，把网关设置成旁路由，或者通过静态分配指定不同客户端指向不同网关。

**由于旁路由 openclash 专属固件默认未设置 53 端口劫持，所以 DHCP 服务器设置中的 DNS 服务器，务必设置成旁路由，不要设置公共 DNS。如果需要配置劫持 53，可参考 [firewall.user](user/common/files/etc/firewall.user) 配置防火墙自定义规则**

##### 2. IPv6

主路由上请勿通告 IPv6 DNS 服务器（这里指 IPv6 地址的 DNS 服务器，如 2400:3200::1）。通过 IPv4 地址的 DNS 服务器解析域名，一样可以拿到 AAAA 记录，所以没必要开启 IPv6 地址的 DNS 服务器，开启反而会增加配置难度，影响 DNS 分流，并可能造成 DNS 泄露。

Openwrt、iKuai、RouterOS 都是支持不通告 IPv6 DNS 的。如果你的主路由不支持，IPv6 DNS 可以填个无效地址，如 `::1`

### 硬件路由固件

- [lede-common-360t7-arm64](user/lede-common-360t7-arm64/README.md)
- [lede-common-newifi_d2-mipsle_softfloat](user/lede-common-newifi_d2-mipsle_softfloat/README.md)

## 命令行修改IP和掩码

注意，旁路由固件默认未开启 DHCP，旁路由固件默认未开启 DHCP，旁路由固件默认未开启 DHCP！

所以，如果不在控制台修改 IP，请修改电脑的 IP 访问，然后可以在网页修改。

```bash
# 作为旁路路由，IP 不建议设置 1，防止和主路由冲突！
# 命令行修改 IP 示例：
uci set network.lan.ipaddr='192.168.1.2'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='192.168.1.1'
uci commit network
```

## 编译和固件个性化流程说明

1. 导出 `Settings.ini` 内容为环境变量
2. 克隆 OpenWRT 源码
3. 安装 `user/common/patches`和`user/[target]/patches` 目录下的补丁
4. 更新 feeds，Update feeds
5. 复制 `user/common/files` 和 `user/[target]/files` 到 `[OpenWRT Code Dir]/files`，注意后者覆盖前者
6. 执行脚本 `user/common/custom.sh` 和 `user/[target]/custom.sh`
7. 安装 feeds，Install feeds
8. 执行 `app_config.sh` 脚本，对插件做自定义，包括下载部分插件需要的二进制执行文件，例如 `clash` 和 `AdGuardHome`
9. 开始编译

## 本地构建指南

使用 [act](https://nektosact.com/) 本地执行 workflow 进行构建。

### 准备环境 Ubuntu 2204

```bash
sudo apt update -y
sudo apt full-upgrade -y
sudo apt install -y ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip python3-pyelftools libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
```

### 安装 act

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

或参考官方文档：[act install](https://nektosact.com/installation/index.html)

### 构建

```bash
source .profile
git clone https://github.com/alecthw/openwrt-actions.git
cd openwrt-actions
act \
    -P ubuntu-latest=-self-hosted \
    -a alecthw \
    -W '.github/workflows/build-openwrt.yml' \
    --matrix target:lede-openclash-x86-amd64 \
    schedule
```

matrix `target` 是 user 目录下下除 common 以外的文件夹名。

## 转换工具下载

- StarWind V2V Converter: [Download link](https://www.starwindsoftware.com/tmplink/starwindconverter.exe)

## 链接

- [chnlist](https://github.com/alecthw/chnlist)
- [coolsnowwolf lede](https://github.com/coolsnowwolf/lede)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)
