# x86-amd64 openclash专属固件

默认IP: `192.168.11.4/24`

密码: `没有密码`，其他涉及默认密码的都是`password`

## 特性

与[common](../lede-common-x86-amd64/README.md)版相比，删除了ssrp，dns跳过了dnsmasq。

默认配置DHCPv6 Client接口`lan6`。

默认配置好了AdGuardHome、mosdns和openclash的搭配运行配置。

- AdGuardHome的监控和广告过滤能力
  - 由于开启了路由本地代理，可以开启AdGuardHome的`浏览安全`和`家长监控`
- mosdns的分流能力，并启用了缓存
- 使用openclash时，dns必须经过openclash，否则Mapping机制问题导致分流可能异常

**以下部分仅仅是说明，无需手动设置。**

修改了dnsmasq的默认端口号，用AdGuardHome监听53端口作为默认的DNS解析，这样可以监控的各个终端的dns请求。

openclash作为AdGuardHome的上游。同时设置openclash复写设置中，启用自定义上游DNS服务器，并指定mosdns为唯一上游。mosdns使用[alecthw修改版](https://github.com/alecthw/mosdns)，支持MMDB GeoIP匹配。

```
AdGuardHome[53, no cache] openclash[7874] --> mosdns[5335, cache]
```

## 使用LEDE源码

[coolsnowwolf's code](https://github.com/coolsnowwolf/lede)

### 主要插件应用

详细参考`[config.diff](config.diff)

- CONFIG_PACKAGE_luci-ssl-openssl
- CONFIG_PACKAGE_luci-app-adguardhome
- CONFIG_PACKAGE_luci-app-autoreboot
- CONFIG_PACKAGE_luci-app-ddns
- CONFIG_PACKAGE_luci-app-firewall
- CONFIG_PACKAGE_luci-app-frpc
- CONFIG_PACKAGE_luci-app-mosdns
- CONFIG_PACKAGE_luci-app-openclash
- CONFIG_PACKAGE_luci-app-ramfree
- CONFIG_PACKAGE_luci-app-tcpdump
- CONFIG_PACKAGE_luci-app-turboacc
- CONFIG_PACKAGE_luci-app-udpxy
- CONFIG_PACKAGE_luci-app-vlmcsd
- CONFIG_PACKAGE_luci-app-wol
- CONFIG_PACKAGE_luci-app-zerotier
