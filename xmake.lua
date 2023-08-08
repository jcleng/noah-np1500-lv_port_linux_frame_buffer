-- 自定义工具链
toolchain("mymips32")
    -- 标记为独立工具链
    set_kind("standalone")
    -- 定义交叉编译工具链地址
    set_sdkdir("/home/jcleng/work/mipseltools-gcc412-lnx26")
    add_linkdirs("/home/jcleng/work/mipseltools-gcc412-lnx26/lib")
    add_includedirs("/home/jcleng/work/mipseltools-gcc412-lnx26/include")
toolchain_end()


target("lvgl_fb.o")  -- 设置目标程序名字
    set_kind("binary")   -- 设置编译成二进制程序，不设置默认编译成二进制程序，可选择编译成动静态库等
    -- 设置使用的交叉编译工具链
    set_toolchains("mymips32")
    -- 设置平台
    set_plat("cross")
    -- 设置架构
    set_arch("mips")
    -- 设置链接的库
    -- add_links("m", "pthread", "ts");

    stdc = "c99"
    set_languages(stdc, "c++11")

    add_files("./*.c")

    -- 递归遍历获取所有子目录
    for _, dir in ipairs(os.dirs("lvgl/src/**")) do
        add_files(dir.."/*.c");
        add_includedirs(dir);
    end

    -- 递归遍历获取所有子目录
    for _, dir in ipairs(os.dirs("lvgl/demos/**")) do
        add_files(dir.."/*.c");   -- 添加目录下所有C文件
        add_includedirs(dir);  -- 添加目录作为头文件搜索路径
    end

    for _, v in ipairs(os.dirs("lv_drivers/**")) do
        add_files(v.."/*.c");
        add_includedirs(v);
    end

    add_includedirs(".")
    -- add_includedirs("/opt/tslib-1.21/include")
