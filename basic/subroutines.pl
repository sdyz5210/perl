#!/usr/bin/perl

=subroutine
	子程序，函数，语法格式如下：
	sub subroutine{
		statements;
	}
	调用方式：subroutine( 参数列表 );
=cut

#函数定义
sub Hello{
	print "Hello,Perl\n";
}

#函数调用
Hello();

#参数传递
=param
	Perl 子程序可以和其他编程一样接受多个参数，子程序参数使用特殊数组 @_ 标明。
	因此子程序第一个参数为 $_[0], 第二个参数为 $_[1], 以此类推。
	不论参数是标量型还是数组型的，用户把参数传给子程序时，perl默认按引用的方式调用它们。
=cut

sub Average{
	# 获取所有传入的参数
	$len = scalar(@_);
	$sum = 0;
	foreach $item(@_){
		$sum+=$item;
	}

	$average = $sum/$len;
	print "average=$average\n";
	print "param=@_\n";
	print "len=$len\n";
}

Average(1,2,3);

#列表参数的传递
sub PrintList{
	@list = @_;
	print "list=@list\n";
}

$age = 10;
@array=(1,2,3,4);

PrintList($age,@array);

#hash参数的传递

sub PrintHash{
	%h = @_;
	foreach $key (keys %h){
		$value = $h{$key};
    	print "$key : $value\n";
	}
}

%h = ("a",1,"b",2);
PrintHash(%h);

#返回值

sub Sum{
	$x = @_[0];
	$y = @_[1];
	print "$x,$y\n";
	$x+$y;#和下一行同样的效果
	#return $x+$y;
}

$a = 2;
$b = 3;
$c = Sum($a,$b);
print "c = $c\n";

=private
	perl中私有变量：
	默认情况下，Perl 中所有的变量都是全局变量，这就是说变量在程序的任何地方都可以调用。
	如果我们需要设置私有变量，可以使用 my 操作符来设置。
	my 操作符用于创建词法作用域变量，通过 my 创建的变量，存活于声明开始的地方，直到闭合作用域的结尾。
	闭合作用域指的可以是一对花括号中的区域，可以是一个文件，也可以是一个 if, while, for, foreach, eval字符串。
=cut 

$str = "Hello,Perl";

sub SayHello{
	print "$str\n";
}

sub SayHi{
	print "$str\n";
}

sub PrintRunoob{
	SayHi();
	local $str;
	$str = "Hi,Perl";
	SayHello();
}

PrintRunoob();
SayHello();
SayHi();

#静态变量
use feature "state";

sub PrintCount{
	state $i = 0;
	print "$i\n";
	$i+=1;
}

for(1..5){
	PrintCount()
}
