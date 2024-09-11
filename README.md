# 概述
* 该项目旨在为Rockchip RK3588设备提供默认的Ubuntu 22.04体验。立即开始使用 Ubuntu 服务器或桌面映像以获得熟悉的环境。
* 支持的设备正在不断开发。因此，您可能会遇到错误或缺少功能。我将尽力使用最新的更改和修复来更新此项目。如果您发现问题，请在问题或讨论部分报告。

## 强调
* 使用官方 Ubuntu 存储库通过 apt 进行包管理
* 通过 apt 接收内核、固件和引导加载程序更新
* 用于用户设置和配置的桌面首次运行向导
* 通过 panfork 提供 3D 视频硬件加速支持
* 基于 Mali GPU 的 OpenGL ES 支持
* 使用 Wayland 完全运行的 GNOME 桌面
* Chromium 浏览器可流畅播放 4k youtube 视频
* 可流畅播放4k视频的MPV视频播放器
* Gstreamer 可用作命令行中的替代 4k 视频播放器
* 支持Rockhip MPP视频硬编码和硬解码
* 预装mpv，支持视频硬解码
* 兼容Docker和Plex服务器
* 6.1.43 Linux 内核

# 安装

### SD卡
* 1.使用工具烧录，三种rufus，win32diskimager,balenaEtcher选个工具，推荐 rufus，免安装，包又小
* rufus安装包在->网盘/6-开发软件/rufus-4.3.exe
* rufus如需安装其他版本，可从 https://rufus.ie/zh/ 下载
* 2.打开rufus，插上SD卡，点击“选择”镜像，可以不用解压，直接选上，点击开始烧录。等待写卡结束即可。

### EMMC启动
* 打开RKDevTool.exe工具，进入maskrom模式，
* 1.选择“下载镜像”下面有名字写着：boot  system
* 2.“boot”选择工具文件夹里面自带名是“rk3588_MiniLoaderAll.bin”点击右边“...”选择bin
* 3.“sysem”选择下载好的镜像，ubuntu**.xz压缩包，进行解压出镜像.img，点击右边“...”选择镜像.img
* 4.下方 打勾“强制按地址写”
* 5.最后点击“执行”正在刷入，等待结束。

# 登录信息
* 对于桌面版和服务器映像，您将能够通过 HDMI 或串行控制台连接登录。预定义用户为`cat`，密码为`temppwd`。

# 编译
### 安装依赖
```
sudo apt-get install -y build-essential gcc-aarch64-linux-gnu bison \
qemu-user-static qemu-system-arm qemu-efi u-boot-tools binfmt-support \
debootstrap flex libssl-dev bc rsync kmod cpio xz-utils fakeroot parted \
udev dosfstools uuid-runtime git-lfs device-tree-compiler python2 python3 \
python-is-python3 fdisk bc
```

### 一键编译桌面版和服务版
```
用法: ./build.sh --board=lubancat-4

所需参数：
  -b, --board=BOARD      target board

可选参数：
  -h,  --help            显示此帮助消息并退出
  -c,  --clean           清理构建目录
  -d,  --docker          使用docker来构建
  -k,  --kernel-only     只编译内核
  -u,  --uboot-only      只编译uboot
  -so, --server-only     只构建服务镜像
  -do, --desktop-only    只构建桌面镜像
  -l,  --launchpad       使用启动板存储库中的内核和 uboot
  -v,  --verbose         增加 bash 脚本的详细程度
```
### 编译鲁班猫4
`sudo ./build.sh --clean --board=lubancat-4`

### 编译鲁班猫5
`sudo ./build.sh --clean --board=lubancat-5`

### 编译鲁班猫5V2
`sudo ./build.sh --clean --board=lubancat-5-v2`

### 进内核目录编译
```
make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 rockchip_linux_defconfig
make KBUILD_IMAGE="arch/arm64/boot/Image" CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 -j"$(nproc)" bindeb-pkg
```

### 进uboot目录编译
`dpkg-buildpackage -a "$(cat debian/arch)" -d -b -nc -uc`

镜像路径在images文件夹下
