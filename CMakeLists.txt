cmake_minimum_required(VERSION 3.1)

# 设置目标系统
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR mips)
set(CMAKE_C_FLAGS "-std=c99")
# 设置工具链目录
set(TOOL_CHAIN_DIR /home/jcleng/desktop/work/mipseltools-gcc412-lnx26-master)
set(TOOL_CHAIN_INCLUDE ${TOOL_CHAIN_DIR}/include ${TOOL_CHAIN_DIR}/mipsel-linux/include)
set(TOOL_CHAIN_LIB ${TOOL_CHAIN_DIR}/lib ${TOOL_CHAIN_DIR}/mipsel-linux/lib)

# 设置编译器位置
set(CMAKE_C_COMPILER "${TOOL_CHAIN_DIR}/bin/mipsel-linux-gcc")
set(CMAKE_CXX_COMPILER "${TOOL_CHAIN_DIR}/bin/mipsel-linux-g++")


# 设置Cmake查找主路径
set(CMAKE_FIND_ROOT_PATH ${TOOL_CHAIN_DIR}/mipsel-linux)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# 只在指定目录下查找库文件
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
# 只在指定目录下查找头文件
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# 只在指定目录下查找依赖包
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
include_directories(${TOOL_CHAIN_DIR}/include ${TOOL_CHAIN_DIR}/mipsel-linux/include)
set(CMAKE_INCLUDE_PATH ${TOOL_CHAIN_INCLUDE})
set(CMAKE_LIBRARY_PATH ${TOOL_CHAIN_LIB})



project(lvgl_fb)
include_directories(.)
add_subdirectory(lvgl)
add_subdirectory(lv_drivers)

add_executable(${PROJECT_NAME} main.c)
target_link_libraries(${PROJECT_NAME} PRIVATE lvgl lvgl::examples lvgl::demos lvgl::drivers)
