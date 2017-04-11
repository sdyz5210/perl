#! /usr/bin/perl

=annatation
Perl 使用一种叫做文件句柄类型的变量来操作文件。
从文件读取或者写入数据需要使用文件句柄。
文件句柄(file handle)是一个I/O连接的名称。
Perl提供了三种文件句柄:STDIN,STDOUT,STDERR，分别代表标准输入、标准输出和标准出错输出。
=cut

# < 以只读形式打开
open(DATA,"<test.txt") or die "test.txt 文件无法打开, $!";

# > 以写的形式打开
open(DATA,">test.txt") or die "test.txt 文件无法打开, $!";

# 以读写的形式打开，但是不删除原有内容
open(DATA,"+<test.txt") or die "test.txt 文件无法打开, $!";

# 以读写的形式打开，但是会删除原有内容
open(DATA,"+>test.txt") or die "test.txt 文件无法打开, $!";

# 文件形式追加
open(DATA,">>test.txt") || die "test.txt 文件无法打开, $!";

# 文件追加，并读取追加的内容
open(DATA,"+>>test.txt") || die "file.txt 文件无法打开, $!";

while(<DATA>){
	#print "$_";
}