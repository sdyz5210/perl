#! /usr/bin/perl

#这输出格式，什么鬼

$text = "google baidu taobao";
format STDOUT =
#左边对齐，字符长度为6
first: ^<<<<<
	$text
#左边对齐，字符长度为6
second: ^<<<<<
	$text
#左边对齐，字符长度为5，taobao 最后一个 o 被截断
third: ^<<<<<
	$text  
.
write