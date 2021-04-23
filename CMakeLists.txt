cmake_minimum_required(VERSION 3.1.0)

project(udsdk_test)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
${CMAKE_CURRENT_SOURCE_DIR}/lib
SYSTEM
/SOURCE/udsdk/include
/SOURCE/udsdksamples/external/stb
)

add_compile_options(-std=c++11)

add_library(udAPP SHARED udSDK.cpp)
target_link_libraries(udAPP
  libudSDK.so
)

add_executable(main main.cpp)
target_link_libraries(main
  udAPP
  libudSDK.so
)

