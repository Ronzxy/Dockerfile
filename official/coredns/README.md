## CoreDNS ##

IMAGE_VERSION=1.6.1
docker run -d --name coredns \
-p 53:53/tcp \
-p 53:53/udp \
-v /storage/docker/coredns/conf:/etc/coredns \
--privileged=true \
--cpu-shares=256 \
--memory=100m --memory-swap=0 \
--oom-kill-disable \
--restart=always \
coredns/coredns:${IMAGE_VERSION} -conf /etc/coredns/Corefile

IMAGE_VERSION=1.6.1
podman run -d --name coredns \
-v /storage/docker/coredns/conf:/etc/coredns \
--net=host \
--cpu-shares=256 \
--memory=100m --memory-swap=0 \
--oom-kill-disable \
docker.io/coredns/coredns:${IMAGE_VERSION} -conf /etc/coredns/Corefile

.:53 {
  # 绑定interface ip
  bind 0.0.0.0
  # 先走本机的hosts
  # https://coredns.io/plugins/hosts/
  hosts {
    # 自定义sms.service search.service 的解析
    # 因为解析的域名少我们这里直接用hosts插件即可完成需求
    # 如果有大量自定义域名解析那么建议用file插件使用 符合RFC 1035规范的DNS解析配置文件
    10.6.6.2 sms.service
    10.6.6.3 search.service
    # ttl
    ttl 60
    # 重载hosts配置
    reload 1m
    # 继续执行
    fallthrough
  }
  # file enables serving zone data from an RFC 1035-style master file.
  # https://coredns.io/plugins/file/
  # file service.signed service
  # 最后所有的都转发到系统配置的上游dns服务器去解析
  # forward . /etc/resolv.conf
  forward . 223.5.5.5 223.6.6.6 8.8.8.8
  # 缓存时间ttl
  cache 120
  # 自动加载配置文件的间隔时间
  reload 6s
  # 输出日志
  log
  # 输出错误
  errors
}

example.org {
    forward . 8.8.8.8
}
