# ImmortalWrt 纯净编译：CMCC RAX3000M

本仓库用 GitHub Actions 自动编译 ImmortalWrt，机型是 CMCC RAX3000M（`cmcc_rax3000m`，联发科 MT7981 Filogic）。

这是纯净版：只选设备 + LuCI + Argon 主题，其他全部用官方默认。没有 adblock、nginx、中文包等额外东西，刷完是英文界面。

源码用 ImmortalWrt master 最新版。

## 仓库里有什么

- `.config`：编译配置。目标平台 mediatek / filogic / cmcc_rax3000m，只勾了 LuCI 和 `luci-theme-argon`，其他用官方默认。
- `diy-part2.sh`：编译前改默认设置。把默认 IP 改成 192.168.10.1，主机名改成 RAX3000M。
- `.github/workflows/build-immortalwrt.yml`：GitHub Actions 工作流。跑在 ubuntu-22.04 上，自动拉源码、更新 feeds、加载 `.config`、执行 diy 脚本、编译、发布成品到 Releases。

## 怎么编译

1. 打开仓库的 **Actions** 页面，点左侧的 **Build ImmortalWrt 最新 (master)**（工作流里的 `REPO_BRANCH` 必须是 `master`，如果还是旧的 `v24.10.4`，先在网页上改成 `master` 再跑，API 改不了工作流文件）。
2. 点 **Run workflow**，ssh 那项选 **false**（选 true 会停在 tmate 等你连 SSH，不会自动编完），再点绿色的 **Run workflow** 按钮。
3. 等它跑完（约 1-2 小时），在 **Releases** 里下载，找这个文件：
   - `immortalwrt-mediatek-filogic-cmcc_rax3000m-squashfs-sysupgrade.itb`：正式固件

改了 `.config` 再推到 main 分支不会自动触发（这个工作流只支持手动触发），要手动去 Actions 跑一次。

## 刷机

- 在现系统 LuCI 里：系统 → 备份与更新 → 上传 sysupgrade.itb，**不要勾选保留配置**（不同系统/不同配置，保留会出问题）。
- 这个是 sysupgrade 格式，只能在已经跑 OpenWrt/ImmortalWrt 的机器上升级，不能直接在原厂 CMCC 网页里当原厂固件刷。
- 刷完网关是 192.168.10.1，首次登录没有密码（登录时设一个），电脑要重拿 IP（子网变了）。
- 刷完是英文界面，要中文的话，WAN 通后 SSH 里跑：`apk add luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn luci-i18n-package-manager-zh-cn`，装完在系统 → 语言与风格里选中文。

## 网关说明

这个纯净版不用官方默认网关 192.168.1.1，改成 192.168.10.1。

- 实现方式：`diy-part2.sh` 里改 `package/base-files/files/bin/config_generate`，把 192.168.1.1 换成 192.168.10.1。
- 刷完后想换网关：在 LuCI 网络 → 接口 → LAN 里改，或 SSH 里 uci 改，重启还在。

## 注意

- 不要把这个仓库的固件刷到亚瑟（jdcloud_re-ss-01）上，也不要把亚瑟的固件刷到 RAX3000M 上，设备不一样，刷错会起不来。
- 这是公开仓库，**不要往里面写宽带账号、WiFi 密码等敏感信息**。
