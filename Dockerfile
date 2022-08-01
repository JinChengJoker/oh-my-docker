FROM ubuntu:20.04

# 备份并重新配置下载源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD sources.list /etc/apt/sources.list

# 更新系统
RUN apt-get update

# 安装软件
RUN yes | apt-get install git zsh curl

# 配置 git
ENV NAME "jincheng"
ENV EMAIL "jinchengjoker@foxmail.com"
RUN git config --global user.name $NAME && git config --global user.email $EMAIL

# 安装 OhMyZsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 安装 nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# 配置 nvm nrm
SHELL ["/bin/bash", "--login", "-c"]
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 16
RUN source $NVM_DIR/nvm.sh &&\
		nvm install $NODE_VERSION && nvm use $NODE_VERSION &&\
		corepack enable &&\
		npm install -g nrm &&\
		nrm use taobao

# 配置 zsh
RUN echo '' >> /root/.zshrc &&\
		echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc &&\
		echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /root/.zshrc &&\
		echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /root/.zshrc

# 将 zsh 设为默认 shell
ENV SHELL /bin/zsh

# 将 vim 设为默认编辑器
# ENV EDITOR=vim
# ENV VISUAL=vim

# 配置语言环境
RUN apt install language-pack-zh-hans -y
ENV LANG zh_CN.UTF-8