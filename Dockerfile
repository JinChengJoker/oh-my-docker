FROM ubuntu:20.04

# 备份并重新配置下载源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD sources.list /etc/apt/sources.list

# 更新系统
RUN apt-get update

# 安装软件
RUN yes | apt-get install git zsh curl

# 安装 OhMyZsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

SHELL ["/bin/zsh", "-c"]

# 安装 nvm
RUN git clone https://github.com/nvm-sh/nvm.git ~/.nvm

# 安装 node、配置包管理工具
ARG NODE_VERSION=16
RUN . ~/.nvm/nvm.sh &&\
		nvm install $NODE_VERSION &&\
		nvm use $NODE_VERSION &&\
		corepack enable &&\
		npm add -g nrm &&\
		nrm use taobao &&\
		yarn config set registry https://registry.npmmirror.com/

# 配置 nvm
RUN echo '' >> ~/.zshrc &&\
		echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc &&\
		echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc &&\
		echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc

# 将 zsh 设为默认 shell
ENV SHELL=/bin/zsh

# 配置语言环境
ENV LANG=C.UTF-8

# 配置时区
ENV TZ=Asia/Shanghai
RUN DEBIAN_FRONTEND=noninteractive apt install tzdata