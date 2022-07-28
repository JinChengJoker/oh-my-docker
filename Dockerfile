FROM ubuntu:20.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# 备份并重新配置下载源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD sources.list /etc/apt/sources.list

# 更新系统
RUN apt-get update

# 安装软件
RUN yes | apt-get install git zsh curl

# 安装 nvm 并启用 corepack
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 16
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
		source $NVM_DIR/nvm.sh &&\
		nvm install $NODE_VERSION &&\
		corepack enable &&\
		npm install -g nrm

# 配置 git
ENV NAME "jincheng"
ENV EMAIL "jinchengjoker@foxmail.com"
RUN git config --global user.name $NAME && git config --global user.email $EMAIL

# 配置 zsh
RUN zsh -c 'git clone https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"' &&\
	zsh -c 'setopt EXTENDED_GLOB' &&\
	zsh -c 'for rcfile in "$HOME"/.zprezto/runcoms/z*; do ln -s "$rcfile" "$HOME/.${rcfile:t}"; done'

# 将 zsh 设为默认 shell
ENV SHELL /bin/zsh

# 将 vim 设为默认编辑器
ENV EDITOR=vim
ENV VISUAL=vim