#! /usr/bin/perl

use File::Copy;
use File::Basename qw<basename dirname>;

readBinFile();

sub readLine{
	open(DATA,"<test.txt") or die "test.txt 文件无法打开, $!";
	while ($line = <DATA>) {
		print "$line\n";
	}
	close(DATA);
}

sub readLines{
	open(DATA,"<test.txt") or die "test.txt 文件无法打开, $!";
	@lines = <DATA>;
	print "@lines";
	#下面是遍历数组
	foreach $line (@lines){
		print "$line\n";
	}
	close(DATA);
}

sub readAll {
	open(DATA,"<test.txt") or die "test.txt 文件无法打开, $!";
	while (<DATA>) {
		print "$_";
	}
	close(DATA);
}

=demo
	undef:是一个标量类型，如果变量是整数，undef就是0 ，如果是字符串，它就是空字符串
	$/:存储的是行分隔符，默认是换行符
=cut 
sub readAll1 {
	open(DATA,"<test.txt") or die "test.txt 文件无法打开, $!";
	$olds = $/;
	$/ = undef;
	$line = <DATA>;
	print "$line";
	$/ = $olds;
	close(DATA);
}

sub readThreeLines{
	open(my $in,"<test.txt") or die "test.txt 文件无法打开, $!";
	my @lines;
	push (@lines, scalar <$in> ) for (4..6); 
	close(DATA);
}

=copyFile
	拷贝文件
=cut
sub copyFile{
	$sourceFile = "test.txt" ;
	$destFile = "test1.txt" ;
	copy($sourceFile,$destFile) || die "Copy failed: $!";
}

sub getFileName {
	$file_with_full_path = "/Users/mac/Documents/data/aes.txt";
	my $filename = basename $file_with_full_path;
	my $dirname = dirname $file_with_full_path;
	print "$filename,$dirname\n";
}

sub readBinFile{
	$sourceFile = "/Users/mac/Documents/data/bactive/MiLib114_S3_L001_R1_001.fastq.gz";
	$destFile = "/Users/mac/Documents/data/bactive/test.fastq.gz" ;
	#copy($sourceFile,$destFile) || die "Copy failed: $!";
	open(DATA1,"<$sourceFile") or die "test.txt 文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "test.txt 文件无法打开, $!";
	binmode(DATA2);
	my $buff;
	while (read (DATA1, $buff, 64*1024)) {
		print DATA2 $buff ;	
	}
	close(DATA2);
	close(DATA1);
}