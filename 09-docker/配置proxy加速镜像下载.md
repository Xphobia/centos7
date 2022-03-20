# docker配置proxy

## http代理配置

### 创建docker服务目录

```
mkdir -p /etc/systemd/system/docker.service.d
```

### 写http proxy配置

```
tee /etc/systemd/system/docker.service.d/http-proxy.conf <<-'EOF'
[Service]
Environment="HTTP_PROXY=http://172.17.78.73:8888"
EOF
```

### 重启docker服务使修改生效

```
systemctl daemon-reload && systemctl restart docker
```

### 查看修改成功

```
systemctl show --property=Environment docker
```

### 参考资料

[Control Docker with systemd](https://docs.docker.com/config/daemon/systemd/)

