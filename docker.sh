#!/bin/bash
_install(){
    if [[ -z "$loc" || "$loc" == "CN" ]]; then
        # 如果是国内地区执行的命令
        echo "使用 阿里云 国内镜像源安装"
        bash <(curl -sL get.docker.com) --mirror Aliyun
        _cn_mirror
    else
        bash <(curl -sL get.docker.com)
    fi
    systemctl start docker
    systemctl enable docker
}
_cn_mirror(){
    daemon="/etc/docker/daemon.json"
    if [[ ! -f "$daemon" ]];then
        echo "配置使用 阿里云 国内镜像源拉取镜像"
        mkdir -p /etc/docker
        echo -e "{\n  \"registry-mirrors\": [\"https://ypzju6vq.mirror.aliyuncs.com\"]\n}" > $daemon
        systemctl daemon-reload
        systemctl restart docker
    fi
}

if [[ "$(command -v docker)" ]];then
    echo "Docker已安装"
else
    loc=$(curl -skL https://api.ip.sb/geoip|grep -o "country_code.*"|cut -d \" -f 3)
    _install
    if [[ "$(command -v docker)" ]];then
        echo "Docker已安装成功"
    else
        echo "Docker安装失败"
    fi
fi
