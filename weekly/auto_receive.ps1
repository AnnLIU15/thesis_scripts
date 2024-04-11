conda activate marl # 不激活无法使用某些库

# 检查环境是否激活

if ($env:CONDA_DEFAULT_ENV -ne "marl") {
    Write-Error "无法激活 conda 环境 'marl'!"
    Exit 1
}

# 运行 Python 代码

~/.conda/envs/marl/python.exe xxxxxxx/auto_receive_msg.py

# 捕获 Python 代码中的错误

if ($LASTEXITCODE -ne 0) {
    Write-Error "Python 代码执行失败!"
}
