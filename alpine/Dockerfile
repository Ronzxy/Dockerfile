FROM alpine:3.8

RUN apk update && apk upgrade --no-cache
RUN apk add --no-cache bash gawk sed grep bc coreutils tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
