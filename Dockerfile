# 基础镜像
FROM centos:latest

# 环境变量
ENV NODE_VERSION=20.x
ENV NPM_REGISTRY=https://registry.npmmirror.com

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置阿里云镜像, https://blog.csdn.net/weixin_44952466/article/details/125632442
RUN mkdir /etc/yum.repos.d.bak && \
    mv /etc/yum.repos.d/* /etc/yum.repos.d.bak/ && \
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's/releasever\//releasever-stream\//g' /etc/yum.repos.d/CentOS-Base.repo && \
    yum clean all && \
    yum makecache

# 安装基础包
# 阿里yum镜像node最新只有10.x
RUN yum install -y epel-release && \
    curl --silent --location https://rpm.nodesource.com/setup_${NODE_VERSION} | bash - && \
    yum install -y nodejs cronie iputils vim curl git

    # 清除缓存，减少镜像大小
    # yum clean all && \
    # rm -rf /var/cache/yum

# 启动crond服务, 设置开启自启动crond
RUN systemctl start crond && \
    systemctl enable crond

# 设置npm镜像
RUN npm config set registry ${NPM_REGISTRY} && \
    npm install -g ts-node

# 设置终端进入的目录
# WORKDIR /root

# Start the bash terminal
CMD ["/bin/bash"]
