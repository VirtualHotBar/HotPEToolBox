<h1 align="center">
  <br>
<img src="https://www.hotpe.top/wp-content/uploads/2022/04/logo.ico" width="150"/>
  <br>
  HotPE 工具箱
  <br>
</h1>

<h4 align="center">一个纯净、强大、优雅的Win11PE</h4>

<p align="center">支持上网、声音、远程、下载、HotPE模块、Edgeless插件、MTP丶RNDIS、Legacy、UEFI、M.2、NVME、USB设备弹出、搜索功能、MSI、BitLocker磁盘解锁、网络共享、U盘启动、本地启动、生成ISO等</p>

<p align="center">
  <a href="https://www.hotpe.top">首页</a> -
  <a href="https://docs.hotpe.top">文档</a> -
  <a href="https://down.hotpe.top">下载站</a>  -
  <a href="https://blog.hotpe.top">Blog</a> 
</p>

## 发布版

请到 https://www.hotpe.top/download 进行下载。

## 使用

###### 1.配置环境

克隆本仓库，安装Python，然后挂载原版系统镜像到虚拟光驱

###### 2.制作内核

运行 "\MakingKernel_First\HotPE生成脚本.PY"  根据提示操作

完成后，在当前目录下会生成Kernel.wim文件，将它移动到项目根目录进行第3步

###### 3.进一步完善

运行"\TrustedInstaller权限.py",会以TrustedInstaller权限启动CMD

在CMD中依次运行0-11脚本，并根据提示操作


![](https://stlcdn.letsdown.cn/gh/VirtualHotBar/pic/picture/img/202207031453096.png)

完成后在项目根目录生成的HotPE工具箱.iso就是成品，可直接虚拟机测试

演示视频：https://www.bilibili.com/video/BV1W3411a7YW?zw



## 许可证

HotPE的自编代码基于MIT许可证开源
