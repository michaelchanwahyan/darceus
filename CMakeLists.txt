#include "udSDK.h"
#include "stb_image.h"
#include "stb_image_write.h"

cmake_minimum_required(VERSION 3.1.0)

project(udsdk_test)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
${CMAKE_CURRENT_SOURCE_DIR}/lib
SYSTEM
/SOURCE/udsdk/include
/SOURCE/udsdksamples/external/stb
/SOURCE/udsdksamples/languages/cpp
/SOURCE/udsdk/lib/ubuntu18.04_GCC_x64
)

add_compile_options(-std=c++11)

add_library(udsamplesSDK SHARED udSDK.cpp)
target_link_libraries(udsamplesSDK
  libudSDK.so
)

add_executable(main main.cpp)
target_link_libraries(main
  udsamplesSDK
  libudSDK.so
)

