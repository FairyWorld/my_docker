# Select the base image
FROM centos:latest

# Set environment variables
ENV NODE_VERSION=20.x
ENV NPM_REGISTRY=https://registry.npmmirror.com

# Replace the default CentOS mirrors with the Aliyun mirrors
RUN rename '.repo' '.repo.bak' /etc/yum.repos.d/*.repo && \
    curl -o /etc/yum.repos.d/Centos-vault-8.5.2111.repo http://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo && \
    curl -o /etc/yum.repos.d/epel-archive-8.repo https://mirrors.aliyun.com/repo/epel-archive-8.repo && \
    sed -i 's/mirrors.cloud.aliyuncs.com/url_tmp/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo && \
    sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo && \
    sed -i 's/url_tmp/mirrors.aliyun.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo && \
    sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/epel-archive-8.repo && \
    yum clean all && \
    yum makecache

# RUN curl -o /etc/yum.repos.d/Centos-8.repo http://mirrors.aliyun.com/repo/Centos-8.repo && \
#     sed -i 's/\$releasever/8/g' /etc/yum.repos.d/Centos-8.repo

# Update the system, install Node.js, crontab, ping, vim, curl, git and other basic tools
RUN yum update -y && \
    yum install -y epel-release && \
    curl --silent --location https://rpm.nodesource.com/setup_${NODE_VERSION} | bash - && \
    yum install -y nodejs cronie iputils vim curl git && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set the npm registry and install ts-node globally
RUN npm config set registry ${NPM_REGISTRY} && \
    npm install -g ts-node

# Set the working directory
WORKDIR /app

# Start the bash terminal
CMD ["/bin/bash"]
