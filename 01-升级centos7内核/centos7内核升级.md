# Centos7内核升级



## 准备系统

安装centos7.6系统，最小安装即可

```bash
[root@localhost ~]# cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core)
```

查看系统当前内核版本

```bash
[root@localhost ~]# uname -sr
Linux 3.10.0-957.el7.x86_64
```



## 准备 ELRepo 仓库

### 导入ELRepo的秘钥

```bash
[root@localhost ~]# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
```

如果是内网环境，需要先配置http代理：

```bash
[root@localhost ~]# export https_proxy=https://172.17.78.73:8888
```

### 启用ELRepo

```bash
yum install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
```

### 查看repo文件

```bash
[root@localhost ~]# cd /etc/yum.repos.d/
[root@localhost yum.repos.d]# ls *.repo
CentOS-Base.repo  CentOS-Debuginfo.repo  CentOS-Media.repo    CentOS-Vault.repo
CentOS-CR.repo    CentOS-fasttrack.repo  CentOS-Sources.repo  elrepo.repo
```

### 查看有哪些内核版本可供安装

```bash
[root@localhost ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
Loaded plugins: fastestmirror
Determining fastest mirrors
 * elrepo-kernel: dfw.mirror.rackspace.com
elrepo-kernel                                                                                   | 3.0 kB  00:00:00     
elrepo-kernel/primary_db                                                                        | 2.0 MB  00:00:16     
Available Packages
kernel-lt.x86_64                                           5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-devel.x86_64                                     5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-doc.noarch                                       5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-headers.x86_64                                   5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-tools.x86_64                                     5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-tools-libs.x86_64                                5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-lt-tools-libs-devel.x86_64                          5.4.144-1.el7.elrepo                           elrepo-kernel
kernel-ml.x86_64                                           5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-devel.x86_64                                     5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-doc.noarch                                       5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-headers.x86_64                                   5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-tools.x86_64                                     5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-tools-libs.x86_64                                5.14.1-1.el7.elrepo                            elrepo-kernel
kernel-ml-tools-libs-devel.x86_64                          5.14.1-1.el7.elrepo                            elrepo-kernel
perf.x86_64                                                5.14.1-1.el7.elrepo                            elrepo-kernel
python-perf.x86_64                                         5.14.1-1.el7.elrepo                            elrepo-kernel
```



## 升级内核

### 安装长期稳定版本（推荐）

```bash
[root@localhost ~]# yum --enablerepo=elrepo-kernel install kernel-lt

```

### 安装最新主线版本（不推荐）

```bash
[root@localhost ~]# yum --enablerepo=elrepo-kernel install kernel-ml
```

### 查看系统上的所有可以内核

```bash
[root@localhost ~]# awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
0 : CentOS Linux (5.4.144-1.el7.elrepo.x86_64) 7 (Core)
1 : CentOS Linux (3.10.0-957.el7.x86_64) 7 (Core)
2 : CentOS Linux (0-rescue-25299d731f1241b094c30c22db42f8a6) 7 (Core)
```

### 设置 grub2

```bash
[root@localhost ~]# grub2-set-default 0
```

>  0 来自上一步的 awk 命令

### 生成 grub 配置文件

```bash
[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.4.144-1.el7.elrepo.x86_64
Found initrd image: /boot/initramfs-5.4.144-1.el7.elrepo.x86_64.img
Found linux image: /boot/vmlinuz-3.10.0-957.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-957.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-25299d731f1241b094c30c22db42f8a6
Found initrd image: /boot/initramfs-0-rescue-25299d731f1241b094c30c22db42f8a6.img
done
```

### 重启验证

```bash
[root@localhost ~]# reboot
[root@localhost ~]# uname -sr
Linux 5.4.144-1.el7.elrepo.x86_64
```



## 参考资料

（1）[ELRepo官网](http://elrepo.org/tiki/HomePage)

（2）[CentOS 7 升级 Linux 内核](https://blog.csdn.net/kikajack/article/details/79396793)

