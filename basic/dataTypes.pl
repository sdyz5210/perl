#!/usr/bin/perl

# 标量  scalar quantity

$age = 10;
$longth = 125;

print "age=",$age," and longth=",$longth,"\n";

#数组

@myfavior=("编程","美女","足球");
print $myfavior[0],"\n";

#哈希
#怎么使用暂时不考虑
#%h=('a'=>1,'b'=>2);

#整型
$num1 = 12;
$num2 = 13;
if ($num1+$num2!=25) {
	print ($num1+$num2,"\n");
}else{
	print ($num1*$num2,"\n");
}

#字符串
$str = '这是一个字符串，
不好意思字符串换行了
	这是新的一行
		在这里结束';
print $str;


