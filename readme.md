# 使用cmake交叉编译lvgl在mips-/dev/fb设备上图形化

![out1.gif](https://img1.imgtp.com/2023/06/01/dTHnkRrP.gif)

- 目标机器

```shell
# cat /proc/cpuinfo
system type             : JZ4740
processor               : 0
cpu model               : Ingenic JZRISC V4.15
BogoMIPS                : 335.05
wait instruction        : yes
microsecond timers      : no
tlb_entries             : 32
extra interrupt vector  : yes
hardware watchpoint     : yes
ASEs implemented        :
shadow register sets    : 1
VCED exceptions         : not available
VCEI exceptions         : not available


# uname -a
Linux np1500.noah.com 2.6.24.3 #50 PREEMPT Wed Oct 28 14:59:13 CST 2009 mips unknown
# ls /dev/fb*
/dev/fb   /dev/fb0
# ls /dev/input/*
/dev/input/event0  /dev/input/mice

gcc -v
# Reading specs from /usr/lib/gcc/mipsel-linux/3.4.4/specs
# Configured with: /var/tmp/releasetool-rpm.tmp/bank-20061023-1709/B-mipsel-linux-rpm/rpmbuild/BUILD/mipssde-6.05.00/configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --disable-gdbtk --enable-languages=c,c++ --without-x --target=mipsel-linux --host=mipsel-linux --build=mipsel-linux
# Thread model: posix
# gcc version 3.4.4 mipssde-6.05.00-20061023

```

项目根据官方的[lv_port_linux_frame_buffer](https://github.com/lvgl/lv_port_linux_frame_buffer) 进行实现


` mouse_cursor_icon.c`暂时不引入,默认是鼠标,但是需要实现的是触摸屏

`lvgl`版本是`v8.3.7.zip`
`lv_drivers` 是 https://github.com/littlevgl/lvgl/tree/49c59f4615857759cc8caf88424324ab6386c888

交叉编译工具链 https://github.com/OpenNoah/mipseltools-gcc412-lnx26


- 技巧

```md
# 编译工具统一用cmake
配置了mips的交叉编译工具链

# 配置文件
`lv_drv_conf.h`和`lv_conf.h`直接使用lv_port_linux_frame_buffer的文件;
修改`lv_drv_conf.h`的`FBDEV_PATH`和`EVDEV_NAME`的位置

# 交叉编译工具链
内核低于2.6是没有下面的定义的,所以需要在work/mipseltools-gcc412-lnx26-master/mipsel-linux/include/linux/input.h文件里面添加
#define ABS_MT_POSITION_X   0x3a    /* Center X surface position */
#define ABS_MT_POSITION_Y   0x3b    /* Center Y surface position */
#define ABS_MT_TRACKING_ID 0x39 /* Unique ID of initiated contact */


# lv_drivers
lv_drivers/win32drv 可以直接删除,已经删除
```

- 环境

```shell
docker run -itd -v /home/jcleng/desktop/work/:/home/jcleng/desktop/work/ --name=ub daocloud.io/library/ubuntu:20.04 bash

# 源
# docker cp ub:/etc/apt/sources.list ./
# docker cp ./sources.list ub:/etc/apt/sources.list


docker exec -it ub bash
# docker rm -f ub

# 安装cmake/make
apt update
apt install cmake
apt install make
apt install file

# 32位程序兼容,好使用工具链
dpkg --add-architecture i386
apt update
apt install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

```

- 编译

```shell
mkdir build
cd build
cmake ..
make

file lvgl_fb
# lvgl_fb: ELF 32-bit LSB executable, MIPS, MIPS-I version 1 (SYSV), dynamically linked, interpreter /lib/ld.so.1, for GNU/Linux 2.4.0, with debug_info, not stripped

```

- 目标机器运行

```shell
# 局域网
telnet 192.168.1.20
root 登录
# 下载
wget http://192.168.1.19:12345/lvgl_fb
# 运行
./lvgl_fb
```
