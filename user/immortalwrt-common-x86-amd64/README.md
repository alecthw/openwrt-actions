# x86-amd64 common 固件, immortalwrt 源码

默认 IP: `192.168.11.4/24`

密码: `没有密码`，其他涉及默认密码的都是 `password`

## 特性

参考 [lede-common-x86-amd64](../lede-common-x86-amd64/README.md)，基本一致。

### 额外插件应用

详细参考 `[config.diff](config.diff)

添加了 `daed`，但是与 AdGuardHome 和 mosdns 配合使用的配置尚未预置。

- CONFIG_PACKAGE_luci-app-daed

## 链接

- [luci-app-daed](https://github.com/QiuSimons/luci-app-daed)
- [dae](https://github.com/daeuniverse/dae)
- [daed](https://github.com/daeuniverse/daed)
