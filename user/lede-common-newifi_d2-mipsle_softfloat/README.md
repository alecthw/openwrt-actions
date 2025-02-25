# Newifi-D2 common 固件

默认 IP: `192.168.1.1/24`

密码: `没有密码`，其他涉及默认密码的都是 `password`

## 特性

常规主路由固件，**非旁路由配置**。

### 主要插件应用

详细参考 `[config.diff](config.diff)

- CONFIG_PACKAGE_automount
- CONFIG_PACKAGE_autosamba
- CONFIG_PACKAGE_ipv6helper
- CONFIG_PACKAGE_luci-ssl-openssl
- CONFIG_PACKAGE_luci-app-autoreboot
- CONFIG_PACKAGE_luci-app-ddns
- CONFIG_PACKAGE_luci-app-firewall
- CONFIG_PACKAGE_luci-app-frpc
- CONFIG_PACKAGE_luci-app-mwan3helper
- CONFIG_PACKAGE_luci-app-ramfree
- CONFIG_PACKAGE_luci-app-ssr-plus
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_IPT2Socks
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_V2ray_Plugin
  - CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan
- CONFIG_PACKAGE_luci-app-syncdial
- CONFIG_PACKAGE_luci-app-turboacc
- CONFIG_PACKAGE_luci-app-upnp
- CONFIG_PACKAGE_luci-app-vlmcsd
- CONFIG_PACKAGE_luci-app-wol
- CONFIG_PACKAGE_luci-app-zerotier
