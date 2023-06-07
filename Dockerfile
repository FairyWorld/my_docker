# Select the base image
FROM centos:latest

# Set environment variables
ENV NODE_VERSION=20.x
ENV NPM_REGISTRY=https://registry.npmmirror.com

# Replace the default CentOS mirrors with the Aliyun mirrors
RUN echo -e "[base]\nname=CentOS-\$releasever - Base\nmirrorlist=http://mirrors.aliyun.com/mirrorlist?repo=centos-\$releasever&arch=\$basearch&protocol=http\nenabled=1\ngpgcheck=1\ngpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official\n\n[updates]\nname=CentOS-\$releasever - Updates\nmirrorlist=http://mirrors.aliyun.com/mirrorlist?repo=centos-\$releasever-updates&arch=\$basearch&protocol=http\nenabled=1\ngpgcheck=1\ngpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-Official" > /etc/yum.repos.d/CentOS-Base.repo

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