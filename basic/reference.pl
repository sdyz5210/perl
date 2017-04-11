#!/usr/bin/perl

=reference
	引用就是指针，Perl 引用是一个标量类型可以指向变量、数组、哈希表（也叫关联数组）甚至子程序，可以应用在程序的任何地方。
	定义变量的时候，在变量名前面加个\，就得到了这个变量的一个引用
	$scalarref = \$foo;     # 标量变量引用
	$arrayref  = \@ARGV;    # 列表的引用
	$hashref   = \%ENV;     # 哈希的引用
	$coderef   = \&handler; # 子过程引用
	$globref   = \*foo;     # GLOB句柄引用
=cut

#在数组中我们可以用匿名数组引用，使用 [] 定义
$href= [ 1,"foo",undef,13 ];
$href= [[1,2,3],[4,5,6],[7,8,9]];

#在哈希中我们可以用匿名哈希引用，使用 {} 定义
$href= { APR =>4, AUG =>8 };

#也可以创建一个没有子程序名的匿名子程序引用
$href = sub{ print "Hello World! \n"; };


#标量
$num = 10;
#标量的引用
$href_num = \$num;
#取消引用--$$href_num

#数组
@array = (1,2,3,4,5);
#数组的引用
$href_array = \@array;
#取消数组的引用----@$href_array

#哈希
%map = ('key1'=>10,'key2'=>12);
#哈希的引用
$href_map = \%map;
#取消哈希的引用--%$href_map





