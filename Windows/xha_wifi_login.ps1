# 定义目标 Wi-Fi 名称
$targetSSIDs = @("OUC-AUTO", "OUC-WIFI")

# 定义登录 URL 和参数
$baseLoginUrl = "https://xha.ouc.edu.cn:802/eportal/portal/login"
$username = "username"  # 请替换为你的用户名
$password = "pwd"    # 请替换为你的密码

# 检测当前 Wi-Fi 名称的函数
function Get-CurrentSSID {
    $wifiInfo = netsh wlan show interfaces | Select-String -Pattern "SSID"
    if ($wifiInfo) {
        # 获取 Wi-Fi 名称（SSID）
        return ($wifiInfo -split ":")[1].Trim()
    }
    return $null
}

# 解析 JSONP 响应的函数
function Parse-JSONPResponse($responseText) {
    # 去除 JSONP 包装并解析 JSON 数据
    $jsonText = $responseText -replace "^jsonpReturn\(", "" -replace "\);$", ""
    return $jsonText | ConvertFrom-Json
}

# 执行登录请求的函数
function Perform-Login {
    # 构造登录 URL
    $loginUrl = "$baseLoginUrl\?user_account=$username&user_password=$password"


    try {
        # 发送登录请求
        $response = Invoke-WebRequest -Uri $loginUrl -Method GET -UseBasicParsing
        # 解析响应
        $result = Parse-JSONPResponse $response.Content
        if ($result.result -eq 1) {
            Write-Host "登录成功！" -ForegroundColor Green
            return $true
        } elseif ($result.ret_code -eq 2) {
            Write-Host "重复登录：$($result.msg)" -ForegroundColor Yellow
            return $true
        } else {
            Write-Host "登录失败：$($result.msg)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "请求出错：" $_.Exception.Message -ForegroundColor Red
        return $false
    }
}

# 主循环：检测 Wi-Fi 名称并尝试登录
while ($true) {
    $currentSSID = Get-CurrentSSID
    if ($targetSSIDs -contains $currentSSID) {
        Write-Host "检测到符合条件的 Wi-Fi: $currentSSID"
        $success = Perform-Login
        if ($success) {
            break  # 登录成功或重复登录，退出循环
        }
    } else {
        Write-Host "未连接到目标 Wi-Fi，当前连接: $currentSSID"
    }
    Start-Sleep -Seconds 5  # 等待 5 秒后重试
}