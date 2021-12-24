# Windows平台下Anaconda安装与使用

## 1. 安装Anaconda

1、下载Anaconda



2、安装Anaconda



安装完成后，打开Anaconda Navigator程序，在Home板块可以看到有个默认的虚拟环境base，下方列出的是该环境中已安装的应用程序，如图：

![image-20200817140225697](C:\Users\qigaoqiang\AppData\Roaming\Typora\typora-user-images\image-20200817140225697.png)

## 2. 使用Anaconda

点击Powershell Prompt应用程序的Launch按钮，启动PS终端进行操作。

### 2.1 conda常用命令

（1）查看安装了哪些包

```powershell
conda list
```

（2）查看当前存在哪些虚拟环境

```powershell
conda env list
```

或者

```powershell
conda info -e
```

（3）检查更新当前conda

```
conda update conda 
```

### 2.2 创建和删除虚拟环境

### 2.2.1 创建虚拟环境

创建python版本为X.X、名字为your_env_name的虚拟环境。your_env_name文件可以在Anaconda安装目录envs文件下找到。

```powershell
conda create -n your_env_name python=X.X
```

（1）创建python2.7虚拟环境

```powershell
conda create -n python27 python=2.7
```

（2）创建python3.6虚拟环境

```powershell
conda create -n python36 python=3.6
```

### 2.2.2 删除虚拟环境

删除名字为 your_env_name的虚拟环境

```powershell
conda remove -n your_env_name --all
```

（1）删除python2.7虚拟环境

```powershell
conda remove -n python27 --all
```

（2）删除python3.6虚拟环境

```powershell
conda remove -n python36 --all
```



## 2.3 激活和退出虚拟环境

默认情况下，当前虚拟环境是base，命令提示符开头的"(base)"表示当前所处的虚拟环境。而新创建的虚拟环境需要激活后才可以使用。

### 2.3.1 激活虚拟环境

（1）激活python27虚拟环境

```powershell
conda activate python27
```

（2）激活python36虚拟环境

```powershell
conda activate python36
```

### 2.3.2 退出虚拟环境

```powershell
conda deactivate
```

退出虚拟环境后，默认回到base虚拟环境，如果再次执行该命令，就会退出base虚拟环境。

## 2.4 虚拟环境中安装和删除包

### 2.4.1 安装包

在虚拟环境your_env_name中安装包package

```
conda install -n your_env_name package
```

### 2.4.2 删除包

删除虚拟环境your_env_name中的包package

```
conda remove --name your_env_name package
```

## 2.5 配置channels加速下载





## 3. 使用Jupyter Notebook



## 3.1 补全代码

### 3.1.2 安装扩展插件jupyter_contrib_nbextensions

```bash
pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple
jupyter nbextensions_configurator enable --user
```

重新打开jupyter notebook，会在菜单栏中发现Nbextensions插件，不勾选disable，然后会看到Hinterland，最后把Hinterland勾选上。如果没有出现Hinterland，再运行一下下面的代码：

```bash
jupyter contrib nbextension install --user --skip-running-check 
```





# 4. 一些有用的python模块

| 名称         | 作用                  | 参考资料                                                 |
| ------------ | --------------------- | -------------------------------------------------------- |
| pysnooper    | 调试打印              |                                                          |
| faulthandler | 调试代码              |                                                          |
| xmltodict    | xml格式字符串转成字典 | https://www.cnblogs.com/zhumengke/articles/11386823.html |
| dicttoxml    | 字典转成xml格式字符串 |                                                          |
|              |                       |                                                          |

