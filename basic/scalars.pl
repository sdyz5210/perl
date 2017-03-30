#!/usr/bin/perl

#scalar 标量

=annotation
	标量是一个简单的数据单元。
	标量可以是一个整数，浮点数，字符，字符串，段落或者一个完整的网页。
=cut

#number

$integer = 10;
$negative = -10;
$floating = 520.1314;
$bigfloat = -1.2E-23;

$octal = 0377;
$hexa = 0xff;

print "integer = $integer\n";
print "negative = $negative\n";
print "floating = $floating\n";
print "bigfloat = $bigfloat\n";
print "octal = $octal\n";
print "hexa = $hexa\n";

#string

$var = "Perl 教程";
$quote = '我是单引号----$var';
$double = "我是单引号----$var";
$escape = "转义字符使用 -\tHello, World!";

print "var = $var\n";
print "quote = $quote\n";
print "double = $double\n";
print "escape = $escape\n";

#scalar calculate

#字符串链接
$str = "Hello"."Perl";
print ("\$str=$str\n");
#加减乘除运算
$num1 = 5+6;
$num2 = 5+6.5;
$num3 = 5/2;
$num4 = 5*2;
$num5 = 5/3;
$num6 = $num1 + $num2;
$num7 = $str.$num1;

print ("\$num1=$num1\n");
print ("\$num2=$num2\n");
print ("\$num3=$num3\n");
print ("\$num4=$num4\n");
print ("\$num5=$num5\n");
print ("\$num6=$num6\n");
print ("\$num7=$num7\n");

#多行字符串的输出

$moreStr1 = 'sss
sss
	sss';
print ("$moreStr1\n");
print "-------------------\n";

$moreStr2 = <<"EOF";
sss
	sss
EOF
print "$moreStr2\n";

#特殊字符

print "文件名 ". __FILE__ . "\n";
print "行号 " . __LINE__ ."\n";
print "包名 " . __PACKAGE__ ."\n";

#v 的使用

$smile  = v9786;
$foo    = v102.111.111;
$martin = v77.97.114.116.105.110; 

print "smile = $smile\n";
print "foo = $foo\n";
print "martin = $martin\n";
