# OUC-AutoLogin

多平台OUC校园网自动认证指南（基于西海岸校区校园网）

The Ultimate Guide to Multi-Platform OUC Campus Network Authentication


## 原理

使用浏览器的开发者工具-网络进行分析，发现OUC校园网的认证通过发送请求至以下 URL 完成：

<https://xha.ouc.edu.cn:802/eportal/portal/login?user_account=你的用户名&user_password=你的密码>

输入上述 URL 并访问时，浏览器会向认证服务器发出一个 GET 请求，模拟登录操作，然后服务器返回的 JSON 则表示认证成功，重复登录，用户名或密码错误等状态。

于是我们就可以通过编写脚本(发送请求，重试机制，状态判断)以及使用各种自动化工具(自动触发脚本程序)来实现无人值守的自动登录。

## 多端实现
1. [Windows](#Windows)
2. [macOS](#macOS)
3. [iOS&iPadOS](#iOSiPadOS)

### Windows

任务计划程序 + Windows PowerShell脚本

1. 下载本仓库Windows文件夹下的脚本xha_wifi_login.ps1和计划程序login_task.xml
2. 将该脚本放置在C:\Scripts\目录下，没有这个目录就新建一个
3. 用记事本打开脚本，将里面的$username$和$password$替换成自己的
3. 按Win+S键搜索任务计划程序并打开
4. 右侧边栏点击导入任务，选择刚刚下载的login_task.xml文件
5. 完成导入，脚本会在开机或联网时自动运行

### macOS

Hammerspoon脚本

1. 前往<https://github.com/Hammerspoon/hammerspoon/releases/>下载并安装最新版Hammerspoon

2. 下载本仓库macOS文件夹下的脚本init.lua

3. 回到访达按cmd+shift+G键前往目录~/.hammerspoon/

4. 将脚本放到该目录下，若有同名文件则覆盖

5. 用文本编辑打开该脚本，将loginURL = '<https://xha.ouc.edu.cn:802/eportal/portal/login?user_account=你的用户名&user_password=你的密码>'中的用户名和密码修改为自己的并保存

6. 点击顶部菜单栏的Hammerspoon图标打开Console控制台，输入print(hs.location.get())并回车

7. 打开系统设置>隐私与安全性>定位服务开启Hammerspoon的权限

8. 点击顶部菜单栏的Hammerspoon图标选择Reload Config重新加载配置

9. 可以在Hammerspoon的Preference设置里添加开机启动，脚本会在开机或联网时自动运行

### iOS&iPadOS

快捷指令 + 自动化

指路这位大佬的repo：<https://github.com/ladeng07/OUC-autoLogin>



