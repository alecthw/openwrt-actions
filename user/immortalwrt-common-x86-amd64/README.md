# x86-amd64 common 固件, immortalwrt 源码

默认 IP: `192.168.11.4/24`

密码: `没有密码`，其他涉及默认密码的都是 `password`

## 特性

参考 [lede-common-x86-amd64](../lede-common-x86-amd64/README.md)，基本一致。

### 额外插件应用

详细参考 `[config.diff](config.diff)

添加了 `daed`，但是与 AdGuardHome 和 mosdns 配合使用的配置尚未预置。如果对 dae 没有一定的**理解**，不建议使用，可能会出现各种问题。

- CONFIG_PACKAGE_luci-app-daed

添加了 `homeproxy`，但是与 AdGuardHome 和 mosdns 配合使用的配置尚未预置。虽然固件保护了 homeproxy，但由于 homeproxy 配置自由度较低，不建议在此固件下使用，需要修改多处 dns 相关的配置。

- CONFIG_PACKAGE_luci-app-homeproxy

## 链接

- [luci-app-daed](https://github.com/QiuSimons/luci-app-daed)
- [dae](https://github.com/daeuniverse/dae)
- [daed](https://github.com/daeuniverse/daed)
