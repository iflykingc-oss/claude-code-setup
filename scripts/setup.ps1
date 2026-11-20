# 配置 Claude Code 使用兼容 Anthropic 协议的网关（Windows PowerShell）
# 用法：
#   .\scripts\setup.ps1 -Key sk-你的密钥           # 当前会话生效
#   .\scripts\setup.ps1 -Key sk-你的密钥 -Persist  # 写入用户环境变量（永久）
param(
    [Parameter(Mandatory = $true)][string]$Key,
    [string]$BaseUrl = "https://api.hardysapi.com",
    [switch]$Persist
)

if (-not $Key.StartsWith("sk-")) {
    Write-Error "密钥应以 sk- 开头，请检查是否复制完整。"
    exit 1
}

if ($Persist) {
    [Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $BaseUrl, "User")
    [Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $Key, "User")
    [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $null, "User")
    Write-Host "已写入用户环境变量。新开终端后运行 claude。"
} else {
    $env:ANTHROPIC_BASE_URL = $BaseUrl
    $env:ANTHROPIC_AUTH_TOKEN = $Key
    Remove-Item Env:ANTHROPIC_API_KEY -ErrorAction SilentlyContinue
    Write-Host "已在当前会话生效。运行 claude 测试。"
}
