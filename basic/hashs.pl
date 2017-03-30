#! /usr/bin/perl

%sites=("baidu","www.baidu.com","google","www.google.com","jd","www.jd.com");
print "\$sites{'baidu'}=$sites{'baidu'}\n";

%sites=("baidu"=>"www.baidu.com","google"=>"www.google.com","jd"=>"www.jd.com");
print "\$sites{'jd'}=$sites{'jd'}\n";

@array=@sites{"baidu","jd"};
print "@array\n";

@names = keys %sites;
print "@names\n";
$len = @names;
print "\@name len:$len\n";

@values = values %sites;
print "@values\n";
$len = @values;
print "\@values len:$len\n";

#增加元素
$sites{"taobao"} = "www.taobao.com";
@names = keys %sites;
print "@names\n";
$len = @names;
print "\@name len:$len\n";

delete $sites{"jd"};
@names = keys %sites;
print "@names\n";
$len = @names;
print "\@name len:$len\n";