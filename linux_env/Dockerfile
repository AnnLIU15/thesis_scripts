# ========== Builder stage ==========
FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8

# 1. 换源 & 安装编译依赖
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential wget tar libevent-dev libncurses-dev bison pkg-config git ca-certificates zsh && \
    # --- Tmux Build ---
    wget -O /tmp/tmux.tar.gz https://github.com/tmux/tmux/releases/download/3.6a/tmux-3.6a.tar.gz && \
    tar -xzf /tmp/tmux.tar.gz -C /tmp && \
    cd /tmp/tmux-3.6a && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    # --- uv Install ---
    wget -qO- https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/ && \
    # --- Zsh Setup ---
    export ZSH_CUSTOM="/root/.oh-my-zsh/custom" && \
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" && \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && \
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && \
    # 配置 Zsh
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /root/.zshrc && \
    sed -i 's/^plugins=.*/plugins=(git extract web-search zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc && \
    find /root/.oh-my-zsh -name ".git" -type d -exec rm -rf {} + && \
    rm -rf /tmp/* /root/.cache

# ========== Final image ==========
FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

# ========================================================
# 【全局一键配置区】
ARG USERNAME=docker-liuzhy
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG GIT_USER="AnnLIU15"
ARG GIT_EMAIL="zhy86ann@outlook.com"
ARG TZ=Asia/Shanghai
# ========================================================

LABEL author=${GIT_EMAIL}

# 环境编码与时区设置
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=${TZ} \
    HOME=/home/${USERNAME} \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/lib/nvidia-000:$LD_LIBRARY_PATH

# 1. 换源 & 安装运行时依赖 & 本地化
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        locales tzdata swig cmake zlib1g-dev libgl1-mesa-dev libosmesa6-dev libglew-dev \
        libcurl4 libevent-2.1-7 libncurses6 sudo zsh openssh-client \
        openssl htop iproute2 curl grep sed dpkg wget bzip2 ffmpeg \
        libx11-6 libxext6 libxrender1 libxrandr2 libxinerama1 libxcursor1 \
        libxi6 libglib2.0-0 git ca-certificates && \
    # 时区配置
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

# 2. 复制二进制文件及基础配置
COPY --from=builder /usr/local/bin/tmux /usr/local/bin/uv /usr/local/bin/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /root/.oh-my-zsh /root/.oh-my-zsh
COPY --from=builder /root/.zshrc /root/

# 3. 系统级配置与用户创建
RUN groupadd -g ${GROUP_ID} ${USERNAME} || true && \
    useradd -l -u ${USER_ID} -g ${GROUP_ID} -m -s /bin/zsh -G sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    # 动态链接库配置
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/local.conf && \
    echo "/usr/lib/x86_64-linux-gnu" >> /etc/ld.so.conf.d/local.conf && ldconfig && \
    echo 'set -g mouse on' > /etc/tmux.conf

# 4. 迁移配置到普通用户 Home
RUN mkdir -p ${HOME}/code ${HOME}/.ssh ${HOME}/.mujoco && \
    cp -r /root/.oh-my-zsh ${HOME}/.oh-my-zsh && \
    cp /root/.zshrc ${HOME}/.zshrc && \
    chown -R ${USER_ID}:${GROUP_ID} ${HOME}

# 切换至新用户
USER ${USERNAME}
WORKDIR ${HOME}/code

# 5. Git & SSH 自动配置 (全量引用变量)
RUN git config --global user.name "${GIT_USER}" && \
    git config --global user.email "${GIT_EMAIL}" && \
    ssh-keygen -t ed25519 -C "${GIT_EMAIL}" -f ${HOME}/.ssh/id_ed25519 -N "" && \
    ssh-keyscan github.com >> ${HOME}/.ssh/known_hosts

# MuJoCo 环境变量
ENV LD_LIBRARY_PATH=${HOME}/.mujoco/mjpro131/bin:${HOME}/.mujoco/mjpro150/bin:${HOME}/.mujoco/mujoco200/bin:${HOME}/.mujoco/mujoco210/bin:$LD_LIBRARY_PATH

CMD ["/bin/zsh"]