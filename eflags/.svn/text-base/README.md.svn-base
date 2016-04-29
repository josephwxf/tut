时间
====
2013年 12月 19日 星期四 ，石磊小组APUE第六章学习

内容
====

# APUE第六章学习的样例代码
# 使用eflags和google gflags的例子程序分发框架
# eflags是参考gflags实现的一个子程序分发框架，
简化了多个小程序在main函数中分发的处理。风格上模仿google gflags。 
# eflags目录下的example.cpp是一个独立的cpp程序，展示eflags的实现原理；
# eflags目录下的其它cpp代码是一个程序。eflags.h eflags.o供上层使用。
# 项目中的gflags版本是在官方2.0版本基础上整合了尚未正式发布的代码
解决了现有2.0版本内存泄露问题。

编译
====
三个部分分开编译

cd gflags-2.0
./configure
make
cd ../eflags
make
cd ..
make


