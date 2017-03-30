#!/usr/bin/perl

#三目运算符

$age = 25;
$result = $age > 18 ? "成年人" : "未成年人";
print "$result\n";

#if 语句
$age = 15;
if ($age>18) {
	print "成年人\n";
}elsif($age>14){
	print "青年人\n";
}else{
	print "少年人\n";
}

#unless 语句

$age=10;
unless ($age>14) {
	print "少年\n";
}

$a = 20;
# 使用 unless 语句检测布尔表达式
unless( $a  ==  30 ){
    # 布尔表达式为 false 时执行
    printf "a 的值不为 30\n";
}elsif( $a ==  30 ){
    # 布尔表达式为 true 时执行
    printf "a 的值为 30\n";
}else{
    # 没有条件匹配时执行
    printf "a  的 值为 $a\n";
}