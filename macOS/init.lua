wifiWatcher = nil
currentSSID = ""
loginTimer = nil
local isLoggingIn = false -- 标志位，防止并发登录请求

-- 定义登录函数
function loginToNetwork()
    if isLoggingIn then
        print("Already attempting to log in. Skipping this attempt.")
        return
    end
    isLoggingIn = true -- 设置为正在登录
    print("Attempting to log in to the campus network...")

    local loginURL = 'https://xha.ouc.edu.cn:802/eportal/portal/login?user_account=你的用户名&user_password=你的密码'

    hs.task.new("/usr/bin/curl", function(exitCode, stdout, stderr)
        isLoggingIn = false -- 登录完成后重置标志位

        if exitCode == 0 then
            print("Response from server: " .. stdout)
            if stdout:find('"ret_code":2') or stdout:find('"result":1') then
                print("Login successful!")
                if loginTimer then loginTimer:stop() end -- 停止重试
            else
                print("Login failed. Retrying...")
                retryLogin()
            end
        else
            print("Error executing curl: " .. stderr)
        end
    end, {loginURL}):start()
end

-- 定义重试逻辑
function retryLogin()
    if loginTimer then loginTimer:stop() end
    loginTimer = hs.timer.doAfter(5, loginToNetwork) -- 每隔 10 秒重试登录
end

-- 定义 Wi-Fi 状态变化回调函数
function ssidChangedCallback()
    local newSSID = hs.wifi.currentNetwork()
    print("Wi-Fi changed to: " .. (newSSID or "None"))

    -- 检查当前 Wi-Fi 是否为目标网络
    if newSSID == "OUC-AUTO" or newSSID == "OUC-WIFI" then
        print("Connected to target Wi-Fi: " .. newSSID)
        if loginTimer then loginTimer:stop() end -- 停止之前的重试计时器
        loginTimer = hs.timer.doAfter(3, loginToNetwork) -- 等待 5 秒后尝试登录
    else
        print("Not connected to target Wi-Fi")
        if loginTimer then loginTimer:stop() end -- 停止任何正在进行的登录重试
    end
end

-- 创建 Wi-Fi 状态监听器
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
print("Wi-Fi watcher started")
