# OUC-AutoLogin

多平台 OUC 校园网自动认证指南（基于西海岸校区校园网）

The Ultimate Guide to Multi-Platform OUC Campus Network Authentication

## 原理

使用浏览器的开发者工具 - 网络进行分析，发现 OUC 校园网的认证通过发送请求至以下 URL 完成：

<https://xha.ouc.edu.cn:802/eportal/portal/login?user_account=你的用户名&user_password=你的密码>

输入上述 URL 并访问时，浏览器会向认证服务器发出一个 GET 请求，模拟登录操作，服务器返回的 JSON 表示认证成功、重复登录、用户名或密码错误等状态。

因此，我们可以通过编写脚本（发送请求、重试机制、状态判断）以及使用各种自动化工具（自动触发脚本程序）来实现无人值守的自动登录。

## 多端实现

1. [Windows](#Windows)
2. [macOS](#macOS)
3. [iOS & iPadOS](#iOS--iPadOS)

### Windows

任务计划程序 + Windows PowerShell 脚本

1. 下载本仓库 Windows 文件夹下的脚本 `xha_wifi_login.ps1` 和计划程序 `login_task.xml`。
2. 将该脚本放置在 `C:\Scripts\` 目录下。如果没有该目录，请新建一个。
3. 用记事本打开脚本文件，将里面的 `username` 和 `password` 替换成自己的账号和密码。
4. 按 `Win+S` 键搜索任务计划程序并打开。
5. 右侧边栏点击“导入任务”，选择刚刚下载的 `login_task.xml` 文件。
6. 需要在选择用户那一栏选择自己当前登录的用户
7. 完成导入后，脚本会在开机或联网时自动运行。

### macOS

Hammerspoon 脚本

1. 前往 [Hammerspoon Releases](https://github.com/Hammerspoon/hammerspoon/releases/) 下载并安装最新版 Hammerspoon。
2. 下载本仓库 macOS 文件夹下的脚本 `init.lua`。
3. 回到访达，按 `cmd+shift+G` 键前往目录 `~/.hammerspoon/`。
4. 将脚本放入该目录，若有同名文件则覆盖。
5. 用文本编辑器打开该脚本，将以下 url 字段中的用户名和密码修改为自己的，并保存：
    ```lua
    loginURL = 'https://xha.ouc.edu.cn:802/eportal/portal/login?user_account=你的用户名&user_password=你的密码'
    ```
6. 点击顶部菜单栏的 Hammerspoon 图标打开 Console 控制台，输入 `print(hs.location.get())` 并回车。
7. 打开系统设置 > 隐私与安全性 > 定位服务，开启 Hammerspoon 的权限。
8. 点击顶部菜单栏的 Hammerspoon 图标选择“Reload Config”重新加载配置。
9. 可以在 Hammerspoon 的偏好设置里添加开机启动，脚本会在开机或联网时自动运行。

### iOS & iPadOS

快捷指令 + 自动化

指路大佬 ladeng07 的 repo：[点我跳转](https://github.com/ladeng07/OUC-autoLogin)

---

### 备注：
- 请根据实际需求修改脚本中的用户名和密码字段。
- 本仓库的相关脚本适用于 OUC 西海岸校区的校园网，其他校区的可能需要适当调整。
