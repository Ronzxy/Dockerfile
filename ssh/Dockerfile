FROM debian:jessie

MAINTAINER GOGS Docker Maintainers "zhangchaoren@openeasy.net"

#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openssh-server ca-certificates libpam-dev && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# SSH login fix, otherwise user is kicked off after login
RUN mkdir /var/run/sshd && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	sed 's@UsePrivilegeSeparation yes@UsePrivilegeSeparation no@' -i /etc/ssh/sshd_config && \
	echo "export VISIBLE=now" >> /etc/profile && \
	echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

# Setup server keys on startup
RUN sed 's@^HostKey@\#HostKey@' -i /etc/ssh/sshd_config && \
	echo "HostKey /etc/ssh/ssh_host_key" >> /etc/ssh/sshd_config && \
	echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config && \
	echo "HostKey /etc/ssh/ssh_host_dsa_key" >> /etc/ssh/sshd_config && \
	echo "HostKey /etc/ssh/ssh_host_ecdsa_key" >> /etc/ssh/sshd_config && \
	echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config

COPY startup.sh /
RUN chmod 755 /startup.sh

EXPOSE 22

CMD ["./startup.sh"]
