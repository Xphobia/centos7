# 开启IOMMU支持PCI-Passthrough特性

## 检查BIOS配置

按F2检查SR-IOV和VT-d支持，确认已经处于ENABLE状态；

## 修改grub配置

### 修改gurb配置模板

如果要在系统启动时加载一个内核参数，需修改GRUB的配置模板(/etc/default /grub)，添加"名称=值”的键值对到GRUB_CMDLINE_LINUX变量，添加多个时用空格隔开。如果没有GRUB_CMDLINE_LINUX变量，可用GRUB_CMDLINE_LINUX_DEFAULT替代。

修改前

```bash
[root@ip-42 pci-passthrough]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
```

修改后

```bash
[root@ip-42 pci-passthrough]# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet intel_iommu=on iommu=pt"
GRUB_DISABLE_RECOVERY="true"
```

### 重新生成grub2

 先判断Linux是以BIOS还是UEFI模式启动，因为二者的grub.cfg文件是不同的。

如果存在/sys/firmware/efi目录，那么LInux是以UEFI模式启动的

```bash
ls /sys/firmware/efi
```

### CentOS

如果Linux是以BIOS模式启动的

```bash
grub2-mkconfig -o /etc/grub2.cfg
```

如果Linux是以UEFI模式启动的

```
grub2-mkconfig -o /etc/grub2-efi.cfg
```

## 重启系统

```
reboot
```

## 网口VT-d挂载测试

### 参考资料

[如何检测Linux是否以Linux的UEFI或BIOS模式运行？](https://blog.csdn.net/cuma2369/article/details/107665680)

[grub生成配置文件_如何在Linux上重新生成Grub2配置文件](https://blog.csdn.net/cuma2369/article/details/107667131)

