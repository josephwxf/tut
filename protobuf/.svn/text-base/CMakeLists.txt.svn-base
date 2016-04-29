#
# cmake 2.8的版本才支持protobuf
# 这句话必须有,即使你的cmake是2.8的
# 其他写法参考/usr/share/cmake-2.8/Modules/FindProtobuf.cmake
#

cmake_minimum_required(VERSION 2.8)

project(PROTOBUF_DEMO)

set(CMAKE_C_FLAGS "-O3")
set(CMAKE_CXX_FLAGS "-O3")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake/)
find_package(Protobuf)
link_libraries(protobuf)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS addressbook.proto )
set(SRC_LIST cpp_pack.cpp ${PROTO_SRCS} )

# 用网上找的cmake protobuf-c modules, 有问题, 依赖关系不对
# 备份为./cmake/FindProtobufC.cmake.org
# 参考/usr/share/cmake-2.8/Modules/FindProtobuf.cmake 
# 修改成 ./cmake/FindProtobufC.cmake 
# 暂时解决


find_package(ProtobufC)
link_libraries(protobuf-c)
protobufc_generate_c(PROTOC_SRCS HDRSC_HDR addressbook.proto)

add_executable(cpp_pack ${SRC_LIST})
add_executable(c_pack c_pack.c ${PROTOC_SRCS})


