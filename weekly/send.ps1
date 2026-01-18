# 虚拟环境 Activate.ps1 脚本的完整路径
$venvActivateScript = "E:\CourseData\.....\rep\Scripts\Activate.ps1"

# 检查文件是否存在，如果存在则激活
if (Test-Path $venvActivateScript) {
    . $venvActivateScript
}
else {
    Write-Error "无法激活虚拟环境 'rep'!"
    Exit 1
}

# 运行发送周报命令
Write-Host "正在发送周报..."
python E:\CourseData\.....\weekly_email.py send

# 检查执行结果
if ($LASTEXITCODE -ne 0) {
    Write-Error "发送周报失败!"
    Exit 1
}

Write-Host "发送完成!"
