#!/usr/bin/perl

#输出Hello Perl

print "Hello Perl\n";
print ("Hello Perl\n");

#这是单行注释

=pod 注释
这是多行注释
这是多行注释
这是多行注释
=cut

#perl 不关心有多少空白
print       "Hello Perl \n";
print "   Hello Perl \n";

#所有类型的空白如：空格，tab ，空行等如果在引号外解释器会忽略它，如果在引号内会原样输出。

print "Hello 	
		Perl\n";


#Perl双引号和单引号的区别: 双引号可以正常解析一些转义字符与变量，而单引号无法解析会原样输出。
$a=10;
print "$a\n";
print '$a\n';

#Here 文档
print ("Here 文档 \n");

$var = <<"EO";
这是一个 Here 文档实例，使用双引号。
可以在这输如字符串和变量。
例如：a = $a
EO
print "$var\n";

$var = <<'EOF';
这是一个 Here 文档实例，使用单引号。
例如：a = $a
EOF
print "$var\n";

#转移字符，使用\进行转义
print "$a \$ \n";