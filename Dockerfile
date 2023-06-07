# Select the base image
FROM centos:latest

# Set environment variables
ENV NODE_VERSION=20.x
ENV NPM_REGISTRY=https://registry.npmmirror.com

# Replace the default CentOS mirrors with the Aliyun mirrors
# RUN curl -o /etc/yum.repos.d/Centos-8.repo http://mirrors.aliyun.com/repo/Centos-8.repo && \
#     rm -f /etc/yum.repos.d/CentOS-Linux-BaseOS.repo /etc/yum.repos.d/CentOS-Linux-AppStream.repo /etc/yum.repos.d/CentOS-Linux-Extras.repo /etc/yum.repos.d/CentOS-Linux-PowerTools.repo

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