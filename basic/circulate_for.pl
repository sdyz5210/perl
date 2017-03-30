#!/usr/bin/perl

# 执行 for 循环
for( $a = 0; $a < 10; $a = $a + 1 ){
	if ($a==6) {
		last;
	}
    print "a 的值为: $a\n";
}

for( $a = 0; $a < 10; $a = $a + 1 ){
	if ($a==6) {
		next;
	}
    print "b 的值为: $a\n";
}

#foreach用来迭代列表
@list = (1,2,3,4,5);
foreach $a (@list){
	print "c 的值为: $a\n";
}