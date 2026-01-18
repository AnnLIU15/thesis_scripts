#!/bin/bash
# setup_skel_v2.sh - 支持自动更新的环境初始化

set -e

# 1. 确保安装基础包
echo "INFO: Installing dependencies..."
sudo apt update && sudo apt install -y zsh git wget

# 1. 清理旧模板
sudo rm -rf /etc/skel/.oh-my-zsh /etc/skel/.zshrc

# 2. 克隆 Oh My Zsh (保留 .git 以支持更新)
sudo git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git /etc/skel/.oh-my-zsh
sudo cp /etc/skel/.oh-my-zsh/templates/zshrc.zsh-template /etc/skel/.zshrc

# 3. 克隆插件与主题 (同样保留 .git)
sudo git clone --depth 1 https://github.com/romkatv/powerlevel10k.git /etc/skel/.oh-my-zsh/custom/themes/powerlevel10k
sudo git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions /etc/skel/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git /etc/skel/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# 4. 修正 .zshrc 模板路径并开启自动更新
sudo sed -i 's|export ZSH=.*|export ZSH="$HOME/.oh-my-zsh"|' /etc/skel/.zshrc
sudo sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /etc/skel/.zshrc
sudo sed -i 's/^plugins=.*/plugins=(git extract web-search zsh-autosuggestions zsh-syntax-highlighting)/' /etc/skel/.zshrc

# 注入自动更新策略：静默自动检查更新
echo 'zstyle :omz:update mode auto' | sudo tee -a /etc/skel/.zshrc
echo 'zstyle :omz:update frequency 13' | sudo tee -a /etc/skel/.zshrc

echo "INFO: /etc/skel is ready for high-performance users!"