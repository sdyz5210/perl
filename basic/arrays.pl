#! /usr/bin/perl

=annotation
	perl数组变量以@开头
=cut

@names=("Tom","John","Merry","Jacky");

print "\$names[0]=$names[0]\n";
print "\$names[1]=$names[1]\n";
print "\$names[2]=$names[2]\n";
print "\$names[3]=$names[3]\n";

@names=(1,2,3,"Lili");
print "\$names[0]=$names[0]\n";
print "\$names[1]=$names[1]\n";
print "\$names[2]=$names[2]\n";
print "\$names[3]=$names[3]\n";

@names=qw/this is a word/;

print "\$names[0]=$names[0]\n";
print "\$names[1]=$names[1]\n";
print "\$names[2]=$names[2]\n";
print "\$names[3]=$names[3]\n";

@names=qw/this
is
a
word/;

print "\$names[0]=$names[0]\n";
#负数为反向读取
print "\$names[-1]=$names[-1]\n";

#定义序列数组
@ages=(10..20);
print "@ages\n";

#length
@arrays = (1,2,3);
$size=@arrays;
$max_index=$#arrays;

print "1--size数组长度：$size\n";
print "1--max_index长度：$max_index\n";
$arrays[10] = 10;
$size=@arrays;
$max_index=$#arrays;
print "2--size数组长度：$size\n";
print "2--max_index长度：$max_index\n";

#数据相关的函数

@sites=("baidu","qq","taobao");
print "no.1--@sites\n";
#在数组后面增加一个元素
push(@sites,"jd");
print "no.2--@sites\n";

#在数组开头增加一个元素
unshift(@sites,"celloud");
print "no.3--@sites\n";

#弹出第一个元素
shift(@sites);
print "no.4--@sites\n";

#移除数组最后一个元素
pop(@sites);
print "no.5--@sites\n";

#切割数组
@citys=("北京","上海","广州","深圳","重庆","天津");
print "@citys\n";

#index指定可以是负数，表示倒序读取
@citys1 = @citys[1,2,-1];
print "@citys1\n";
@citys2 = @citys[1..3];
print "@citys2\n";

=annotation perl中数组元素替换
	splice @ARRAY, OFFSET [ , LENGTH [ , LIST ] ]
	@ARRAY：要替换的数组。
	OFFSET：起始位置。
	LENGTH：替换的元素个数。
	LIST：替换元素列表。
=cut

@temps=("济南","成都");
splice(@citys,2,2,@temps);
print "splice--@citys\n";

#splice(@citys,2,1,@temps);
#print "splice--@citys\n";
#如果替换的元素个数<list的长度，会造成数组长度增加，上述执行结果如下
#splice--北京 上海 济南 成都 深圳 重庆 天津

$strs="abc";
@strs = split('',$strs);
print "@strs\n";
$strs=join("-",@strs);
print "$strs\n";

#数据排序--sort

@numbers=(10,45,23,63,58,95,14);
print "@numbers\n";
@numbers=sort(@numbers);
print "@numbers\n";
