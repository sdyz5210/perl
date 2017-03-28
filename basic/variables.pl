#! /usr/bin/perl

#variable 变量

=pod 
	Perl 为每个变量类型设置了独立的命令空间，所以不同类型的变量可以使用相同的名称，你不用担心会发生冲突。
	例如 @foo 和 $foo 是两个不同的变量
	但是在软件工程实践中，不推荐此命名规范

	变量不需要显式声明类型，在变量赋值后，解释器会自动分配匹配的类型空间。
	变量使用等号(=)来赋值。

	在程序中使用 use strict 语句让所有变量需要强制声明类型
=cut

$age = 25;
$str = "Hello Perl";
$salary = 145.23;

#scalar 标量

print "Age = $age\n";
print "str = $str\n";
print "Salary = $salary\n";

#array

@myfavior=("编程","美女","足球");
print "\$myfavior[0]=$myfavior[0]\n";
print "\$myfavior[1]=$myfavior[1]\n";
print "\$myfavior[2]=$myfavior[2]\n";

#hash
%h=('a'=>1,'b'=>2);
print "\$h{'a'}=$h{'a'}\n";
print "\$h{'b'}=$h{'b'}\n";

%hh=('google',100,'baidu',70);
print "\$hh{'google'}=$hh{'google'}\n";
print "\$hh{'baidu'}=$hh{'baidu'}\n";

#context
=pod
	标量的上下文由左侧的决定。
	下面的例子，把一个数组赋值给一个标量，获取的是数据的大小
=cut
@names=("baidu","taobao","qq");
@copyName = @names;
$sizeName = @names;

print "\@copyName=@copyName\n";
print "\$sizeName=$sizeName\n";