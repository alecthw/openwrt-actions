# x86-amd64 common 固件, lede 源码

默认 IP: `192.168.11.4/24`

密码: `没有密码`，其他涉及默认密码的都是 `password`

## 特性

默认配置 DHCPv6 Client 接口 `lan6`。

默认配置好了 AdGuardHome、mosdns 和 openclash（或 ssrp）的搭配运行配置。

openclash 预置 `mihomo(原clash_meta)` 内核。

- AdGuardHome 的监控和广告过滤能力
  - 由于开启了路由本地代理，可以开启 AdGuardHome 的`浏览安全`和`家长监控`
- mosdns 的分流能力，并启用了缓存
- 使用 openclash 时，dns 必须经过 openclash，否则 Mapping 机制问题导致分流可能异常

**以下部分仅仅是说明，无需手动设置。**

修改了 dnsmasq 的默认端口号，用 AdGuardHome 监听 53 端口作为默认的 DNS 解析，这样可以监控的各个终端的 DNS 请求。openclash 作为 AdGuardHome 的上游，mosdns 作为 AdGuardHome 的上游备用服务器。

``` txt
                          主要
AdGuardHome[53, no cache] ────⟶ openclash[7874] ────⟶ mosdns[5335, cache]
                          |                           ↑
                          └───────────────────────────┘
                                      备用
```

### 配合 openclash

openclash 中`本地 DNS 劫持`设置`停用`，当 openclash 运行时，openclash 作为 AdGuardHome 的上游主要服务器`生效`。

同时设置 openclash 复写设置中，启用自定义上游 DNS 服务器，并指定 mosdns 为唯一上游。

mosdns 使用 [alecthw 修改版](https://github.com/alecthw/mosdns)，支持 MMDB GeoIP 匹配。

#### Clash 订阅引起 DNS 问题的说明

**这里非常重要，请认真看完。**

目前很多机场提供的 Clash 订阅里，配置了复杂的 DNS 分流导致插件无法完全覆盖 DNS 配置，最终引起 DNS 分流异常引发上网异常。

因此，固件预置了三份配置文件，建议**仅订阅节点**，不使用机场提供的配置。

三分配置文件说明：

- APP_Rule_Auto.yaml：大陆白名单模式（CN 走直连，最终未命中规则默认走代理），**包含细致的 APP 分流规则**，节点按照国家分组，国家分组内**需手动选择节点**
- APP_Rule_Manual.yaml：大陆白名单模式（CN 走直连，最终未命中规则默认走代理），**包含细致的 APP 分流规则**，节点按照国家分组，国家分组内**根据延迟自动选择**
- Only_CN_Rule_Auto.yaml：大陆白名单模式（CN 走直连，最终未命中规则默认走代理），**不含 APP 规则**，节点按照国家分组，国家分组内**根据延迟自动选择**

如何仅订阅节点：

- 在`配置管理`中，点击`切换`激活想使用的配置（默认 Only_CN_Rule_Auto.yaml），然后直接在下方修改左边的配置文件，找到 `proxy-providers`，将其中 `Subscribe` 下的 `url`，改成机场提供的 Clash 订阅地址，然后点击`保存配置`→`应用配置`。

### 配合 ssrp

如果使用 ssrp，ssrp 设置`使用本机端口为 5335 的 DNS 服务`。ssrp 使用 dnsmasq 分流，dnsmasq 默认端口被修改了，所以这里实际不生效，实际是经过 AdGuardHome → mosdns，在 mosdns 中分流。

由于 openclash 未启动，AdGuardHome 的上游主要服务器`失效`，备用服务器 mosdns `生效`。

### 主要插件应用

详细参考 `[config.diff](config.diff)

- CONFIG_PACKAGE_autocore-x86
- CONFIG_PACKAGE_automount
- CONFIG_PACKAGE_autosamba
  - CONFIG_PACKAGE_autosamba_INCLUDE_KSMBD
- CONFIG_PACKAGE_ipv6helper
- CONFIG_PACKAGE_luci-ssl-openssl
- CONFIG_PACKAGE_luci-app-adguardhome
- CONFIG_PACKAGE_luci-app-autoreboot
- CONFIG_PACKAGE_luci-app-ddns
- CONFIG_PACKAGE_luci-app-firewall
- CONFIG_PACKAGE_luci-app-frpc
- CONFIG_PACKAGE_luci-app-mosdns
- CONFIG_PACKAGE_luci-app-openclash
- CONFIG_PACKAGE_luci-app-ramfree
- CONFIG_PACKAGE_luci-app-snmpd
- CONFIG_PACKAGE_luci-app-ssr-plus
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_libustream-openssl
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Libev_Client
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_NONE_Server
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Xray
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_IPT2Socks
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan
- CONFIG_PACKAGE_luci-app-turboacc
- CONFIG_PACKAGE_luci-app-udpxy
- CONFIG_PACKAGE_luci-app-vlmcsd
- CONFIG_PACKAGE_luci-app-wol
- CONFIG_PACKAGE_luci-app-zerotier
- CONFIG_PACKAGE_luci-theme-argon-jerrykuku
- CONFIG_PACKAGE_luci-theme-design
