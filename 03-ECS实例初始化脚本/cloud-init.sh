

yum install -y git tree lrzsz lsof
yum install -y python36

# 网络相关
yum install -y nmap-ncat net-tools bridge-utils


# 安装man手册
yum install -y man-pages

# 安装编译工具
yum install -y gcc gcc-c++

# 编译32位程序时(gcc -m32)
yum install -y libgcc.i686
