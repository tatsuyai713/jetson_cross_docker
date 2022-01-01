set(CMAKE_SYSTEM_NAME Linux) 
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".so")
set(ARCH "aarch64")

add_definitions(-DENABLE_PRECOMPILED_HEADERS=OFF)

# Specify the cross compiler 
set(TOOLCHAIN "$ENV{HOME}/l4t-gcc") 
set(CMAKE_CXX_COMPILER "${TOOLCHAIN}/bin/aarch64-linux-gnu-g++") 
set(CMAKE_C_COMPILER "${TOOLCHAIN}/bin/aarch64-linux-gnu-gcc") 

# Targetfs path 
set(ROS_SYSROOT "$ENV{HOME}/host_home/jetpack") 

# Library paths 
set(LD_PATH "${ROS_SYSROOT}/usr/lib/aarch64-linux-gnu") 
set(LD_PATH_EXTRA "${ROS_SYSROOT}/lib/aarch64-linux-gnu")
set(LD_PATH_EXTRA_1 "${ROS_SYSROOT}/usr/local/cuda-10.2/lib64")
set(LD_PATH_EXTRA_2 "${ROS_SYSROOT}/usr/lib/aarch64-linux-gnu/tegra")


# setup compiler for cross-compilation 
set(CMAKE_CXX_FLAGS           "-fPIC"               CACHE STRING "c++ flags") 
set(CMAKE_C_FLAGS             "-fPIC"               CACHE STRING "c flags") 
set(CMAKE_SHARED_LINKER_FLAGS ""                    CACHE STRING "shared linker flags") 
set(CMAKE_MODULE_LINKER_FLAGS ""                    CACHE STRING "module linker flags") 
set(CMAKE_EXE_LINKER_FLAGS    ""                    CACHE STRING "executable linker flags") 
set(CMAKE_FIND_ROOT_PATH ${ROS_SYSROOT}) 

# Set compiler flags 
set(CMAKE_SHARED_LINKER_FLAGS   "--sysroot=${CMAKE_FIND_ROOT_PATH} -L${LD_PATH} -L${LD_PATH_EXTRA} -L${LD_PATH_EXTRA_1} -L${LD_PATH_EXTRA_2} -Wl,-rpath,${LD_PATH} -Wl,-rpath,${LD_PATH_EXTRA} -Wl,-rpath,${LD_PATH_EXTRA_1} -Wl,-rpath,${LD_PATH_EXTRA_2} ${CMAKE_SHARED_LINKER_FLAGS}") 
set(CMAKE_MODULE_LINKER_FLAGS   "--sysroot=${CMAKE_FIND_ROOT_PATH} -L${LD_PATH} -L${LD_PATH_EXTRA} -L${LD_PATH_EXTRA_1} -L${LD_PATH_EXTRA_2} -Wl,-rpath,${LD_PATH} -Wl,-rpath,${LD_PATH_EXTRA} -Wl,-rpath,${LD_PATH_EXTRA_1} -Wl,-rpath,${LD_PATH_EXTRA_2} ${CMAKE_SHARED_LINKER_FLAGS}") 
set(CMAKE_EXE_LINKER_FLAGS      "--sysroot=${CMAKE_FIND_ROOT_PATH} -L${LD_PATH} -L${LD_PATH_EXTRA} -L${LD_PATH_EXTRA_1} -L${LD_PATH_EXTRA_2} -Wl,-rpath,${LD_PATH} -Wl,-rpath,${LD_PATH_EXTRA} -Wl,-rpath,${LD_PATH_EXTRA_1} -Wl,-rpath,${LD_PATH_EXTRA_2} ${CMAKE_EXE_LINKER_FLAGS}") 
set(CMAKE_C_FLAGS "-fPIC --sysroot=${CMAKE_FIND_ROOT_PATH} -fpermissive -g" CACHE INTERNAL "" FORCE) 
set(CMAKE_CXX_FLAGS "-fPIC --sysroot=${CMAKE_FIND_ROOT_PATH} -fpermissive -g" CACHE INTERNAL "" FORCE) 

set(CMAKE_LIBRARY_PATH "${LD_PATH} ${LD_PATH_EXTRA} ${LD_PATH_EXTRA_1}")

# Search for programs only in the build host directories 
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER) 
# Search for libraries and headers only in the target directories 
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY) 
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY) 

#for CUDA
set(CUDA_64_BIT_DEVICE_CODE ON)
set(CMAKE_CUDA_HOST_COMPILER ${TOOLCHAIN}/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CUDA_HOST_LINK_LAUNCHER /usr/local/cuda-10.2/bin/nvcc )
set(CMAKE_CUDA_COMPILER /usr/local/cuda-10.2/bin/nvcc )
set(CUDA_TOOLKIT_ROOT_DIR /usr/local/cuda-10.2)
set(CUDA_INCLUDE_DIRS ${ROS_SYSROOT}/usr/local/cuda-10.2/targets/aarch64-linux/include/ ${CUDA_INCLUDE_DIRS})
INCLUDE(FindCUDA)

set(CUDA_CUDART_LIBRARY ${ROS_SYSROOT}/usr/local/cuda-10.2/targets/aarch64-linux/lib ${ROS_SYSROOT}/usr/local/cuda-10.2/targets/aarch64-linux/lib/stubs)


# set system default include dir
include_directories(BEFORE SYSTEM ${TOOLCHAIN}/include)
