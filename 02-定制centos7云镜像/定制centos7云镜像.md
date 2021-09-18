# 定制centos7云镜像



## 下载基础云镜像

官网下载地址：http://cloud.centos.org/centos/7/images/

下载命令：

```bash
curl -O https://mirrors.ustc.edu.cn/centos-cloud/centos/7/images/CentOS-7-x86_64-GenericCloud-1905.qcow2
```

或者，下载压缩版本再解压（推荐）

```bash
[root@localhost ~]# curl -O http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1811.qcow2.xz
[root@localhost ~]# xz -dk CentOS-7-x86_64-GenericCloud-1811.qcow2.xz
[root@localhost ~]# ll -h
total 1.2G
-rw-------. 1 root root 1.4K Sep 19 02:06 anaconda-ks.cfg
-rw-r--r--. 1 root root 895M Sep 19 03:11 CentOS-7-x86_64-GenericCloud-1811.qcow2
-rw-r--r--. 1 root root 262M Sep 19 03:11 CentOS-7-x86_64-GenericCloud-1811.qcow2.xz
```



## 安装镜像定制工具

### 安装DIB和Virt

```bash
[root@localhost ~]# yum install -y centos-release-openstack-train
[root@localhost ~]# yum install -y diskimage-builder
[root@localhost ~]# yum install -y libguestfs-tools-c libguestfs-tools libguestfs
```

安装其他包

```bash
# 设置disable-selinux时需要semanage命令
[root@localhost ~]# yum install -y policycoreutils-python
```



## 开始定制镜像

### 查看镜像信息

```bash
[root@localhost ~]# export LIBGUESTFS_BACKEND=direct
[root@localhost ~]# virt-inspector -a CentOS-7-x86_64-GenericCloud-1811.qcow2 > report.xml
[root@localhost ~]# head report.xml 
<?xml version="1.0"?>
<operatingsystems>
  <operatingsystem>
    <root>/dev/sda1</root>
    <name>linux</name>
    <arch>x86_64</arch>
    <distro>centos</distro>
    <product_name>CentOS Linux release 7.6.1810 (Core) </product_name>
    <major_version>7</major_version>
    <minor_version>6</minor_version>
```

### 设置环境变量

```bash
[root@localhost ~]# export LIBGUESTFS_BACKEND=direct
[root@localhost ~]# export DIB_LOCAL_IMAGE="/root/CentOS-7-x86_64-GenericCloud-1811.qcow2" 
[root@localhost ~]# export DIB_RELEASE=7
[root@localhost ~]# export DIB_CLOUD_INIT_ALLOW_SSH_PWAUTH="yes"
[root@localhost ~]# export DIB_AVOID_PACKAGES_UPDATE=1
[root@localhost ~]# export image_name='CentOS-7.6-x86.qcow2'
```

### openstack平台

```bash
[root@localhost ~]# DIB_CLOUD_INIT_DATASOURCES="ConfigDrive, OpenStack"  disk-image-create -a amd64 -o $image_name  -x --image-size 40 vm base centos disable-selinux cloud-init cloud-init-datasources dhcp-all-interfaces growroot epel
```

### zstack平台

```bash
[root@localhost ~]# disk-image-create -a amd64 -o  $image_name -x --image-size 40 vm base centos disable-selinux cloud-init dhcp-all-interfaces epel
```

### 其他设置

```bash
# root 密码
[root@localhost ~]# virt-customize -a $image_name --root-password password:123456 

# 设置时区
[root@localhost ~]# virt-customize -a $image_name --timezone "Asia/Shanghai" 

#安装工具
[root@localhost ~]# virt-customize -a $image_name --install epel-release
[root@localhost ~]# virt-customize -a $image_name --install net-tools,wget,vim,unzip,qemu-guest-agent,jq,bash-completion,yum-utils,device-mapper-persistent-data,lvm2,openssl,socat,conntrack,ebtables,ipset,sysstat,iotop,iftop,nload,bridge-utils,bash-completion,bind-utils,nc,binutils,iscsi-initiator-utils,kmod-xfs,xfsprogs,sg3_utils-devel.x86_64,sg3_utils-libs.x86_64,sg3_utils.x86_64,psmisc

#启动服务
[root@localhost ~]# virt-customize -a $image_name --run-command 'systemctl enable qemu-guest-agent' 

#SSH服务
[root@localhost ~]# virt-customize -a $image_name --edit '/etc/ssh/sshd_config:s/GSS/#GSS/'
[root@localhost ~]# virt-customize -a $image_name --edit '/etc/ssh/sshd_config:s/#UseDNS yes/UseDNS no/'

#vim
[root@localhost ~]# virt-customize -a $image_name --append-line '/etc/profile:alias vi=vim'
[root@localhost ~]# virt-customize -a $image_name --append-line '/etc/profile:unset MAILCHECK'

#查看修改
[root@localhost ~]# virt-cat -a $image_name /etc/ssh/sshd_config 

#清理
[root@localhost ~]# virt-customize -a $image_name --run-command 'yum clean all'
[root@localhost ~]# virt-customize -a $image_name --run-command 'yum makecache'
```

### 安装zstack的agent

```bash
[root@localhost ~]# virt-customize -a $image_name --firstboot-command '/bin/bash -c "$(curl -s -S http://169.254.169.254/vm-tools.sh)"'
[root@localhost ~]# virt-customize -a $image_name --firstboot-command "/bin/systemctl restart zwatch-vm-agent.service"
```

当多个启动脚本要运行，需要设置一下他们的优先级，默认是安装字母顺序来运行，所以我把重启agent的改成02。

```bash
[root@localhost ~]# virt-customize -a $image_name --run-command 'mv /usr/lib/virt-sysprep/scripts/0001--bin-systemctl-restart-zwatch-vm-agent-service /usr/lib/virt-sysprep/scripts/0002--bin-systemctl-restart-zwatch-vm-agent-service'
```

查看修改后的结果

```bash
[root@localhost ~]# virt-ls  -a $image_name  /usr/lib/virt-sysprep/scripts
0001--bin-bash--c----curl--s--S-http---169-254-169-254-vm-tools-s
0002--bin-systemctl-restart-zwatch-vm-agent-service
```



## 上传镜像

```bash
[root@localhost ~]# nohup python -m SimpleHTTPServer > /dev/null 2>&1 &
```

zstack根据url添加镜像：http://192.168.1.106:8080/CentOS-7.6-x86.qcow2



## 参考资料

（1）[做一个CentOS 7.6镜像](http://www.chenshake.com/do-a-centos-7-6-mirror-image-of-a/)

