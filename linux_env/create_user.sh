#!/bin/bash

# =============================================================================
# create_user.sh - 2026 最终生产版
# =============================================================================
# 功能：
#   1. 系统创建原生用户名（如 test）
#   2. 管理员目录备份带后缀私钥（如 test-gpu4）
#   3. 自动配置 Zsh 环境（继承 /etc/skel）
#   4. 自动开启 Oh My Zsh 自动更新模式
# =============================================================================

# 遇到错误立即退出
set -e

# -----------------------------------------------------------------------------
# 配置区域 (FLAG)
# -----------------------------------------------------------------------------
SUFFIX="-gpu4"       # 私钥备份文件后缀
sudoer1="labi3c"     # 管理员账号（私钥存放处）
UserLocation="/home" # 用户主目录根路径

# -----------------------------------------------------------------------------
# 参数解析
# -----------------------------------------------------------------------------
username="$1"

if [ -z "$username" ]; then
    echo "Usage: $0 <username> [--sudo <password>]"
    echo "Example: $0 zhangsan --sudo 123456"
    exit 1
fi

# 定义备份时的私钥文件名
backup_name="${username}${SUFFIX}"

use_sudo=0
user_password=""

# 解析 --sudo 参数
for ((i=2; i<=$#; i++)); do
    arg="${!i}"
    if [ "$arg" = "--sudo" ]; then
        use_sudo=1
        ((i++))
        if [ $i -le $# ]; then
            user_password="${!i}"
        fi
    fi
done

# -----------------------------------------------------------------------------
# 步骤 1: 确定 Shell 环境
# -----------------------------------------------------------------------------
# 优先使用 Zsh，如果系统未安装则回退到 Bash
if command -v zsh >/dev/null 2>&1 && [ -f "/etc/skel/.zshrc" ]; then
    target_shell="/bin/zsh"
else
    target_shell="/bin/bash"
fi

# -----------------------------------------------------------------------------
# 步骤 2: 创建系统用户
# -----------------------------------------------------------------------------
echo "INFO: Starting setup for user: $username"

if [ $use_sudo -eq 1 ] && [ -n "$user_password" ]; then
    # 使用 openssl 生成 SHA-512 加密密码
    encrypted_pass=$(openssl passwd -6 "$user_password")
    useradd -m -s "$target_shell" -p "$encrypted_pass" "$username" && usermod -aG sudo "$username"
    echo "INFO: User created with sudo privileges."
else
    useradd -m -s "$target_shell" "$username"
    echo "INFO: User created as regular user."
fi

# -----------------------------------------------------------------------------
# 步骤 3: 权限修复与目录初始化
# -----------------------------------------------------------------------------
# 1. 递归修正所有权 (非常关键：确保从 /etc/skel 拷贝的 Zsh 插件属于新用户)
#    只有这样，Oh My Zsh 的自动更新 (git pull) 才有权限运行
chown -R "$username:$username" "$UserLocation/$username"

# 2. 设置主目录权限（SSH 严苛要求）
chmod 700 "$UserLocation/$username"

# 3. 创建并配置 .ssh 目录
mkdir -p "$UserLocation/$username/.ssh"
chmod 700 "$UserLocation/$username/.ssh"
chown "$username:$username" "$UserLocation/$username/.ssh"

# -----------------------------------------------------------------------------
# 步骤 4: 生成 SSH 密钥对
# -----------------------------------------------------------------------------
echo "INFO: Generating 4096-bit RSA keys..."
# 以新用户身份运行密钥生成，确保私钥原生属于该用户
sudo -u "$username" ssh-keygen -t rsa -b 4096 -N "" -f "$UserLocation/$username/.ssh/id_rsa" -q

# -----------------------------------------------------------------------------
# 步骤 5: 配置授权与私钥备份
# -----------------------------------------------------------------------------
# 将公钥放入授权文件
mv "$UserLocation/$username/.ssh/id_rsa.pub" "$UserLocation/$username/.ssh/authorized_keys"
chmod 600 "$UserLocation/$username/.ssh/authorized_keys"
chown "$username:$username" "$UserLocation/$username/.ssh/authorized_keys"

# 备份私钥到管理员目录，并添加服务器后缀
mkdir -p "$UserLocation/$sudoer1/ssh_keys"
cp "$UserLocation/$username/.ssh/id_rsa" "$UserLocation/$sudoer1/ssh_keys/$backup_name"

# 设置备份文件的所有权和权限
chown "$sudoer1:$sudoer1" "$UserLocation/$sudoer1/ssh_keys/$backup_name"
chmod 600 "$UserLocation/$sudoer1/ssh_keys/$backup_name"

# 确保用户自己的私钥权限正确
chmod 600 "$UserLocation/$username/.ssh/id_rsa"

# -----------------------------------------------------------------------------
# 步骤 6: 附加组设置 (如 Docker)
# -----------------------------------------------------------------------------
if getent group docker > /dev/null 2>&1; then
    usermod -aG docker "$username"
    echo "INFO: User added to docker group."
fi

# -----------------------------------------------------------------------------
# 步骤 7: 完成输出
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "SUCCESS: User '$username' is fully configured!"
echo "SHELL: $target_shell (Oh My Zsh + Auto-update)"
echo "HOME:  $UserLocation/$username"
echo "KEY BACKUP: $UserLocation/$sudoer1/ssh_keys/$backup_name"
echo "============================================================"