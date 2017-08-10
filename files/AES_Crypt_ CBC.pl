#! /usr/bin/perl

use strict;
use Crypt::CBC;
use MIME::Base64;

=encrypt string
	加密字符串
	$iv和$header配对出现,可以同时去掉,如果去掉，每次加密的结果都会发生变化。

=cut
sub encryptString{
	my $key = "1234567890abcdef";
	my $algorithm = "Rijndael";
	my $iv = "abcdef0123456789" ;
	my $str = "Hello World!!!";
	my $cipher = Crypt::CBC->new(
			-key => $key,
			-cipher => $algorithm,
			-iv => $iv,
			-header => 'none',
		);
	my $str_en = $cipher->encrypt($str);
	print encode_base64($str_en);
	print "\n";
	my $str_de = $cipher->decrypt($str_en);
	print "$str_de";
}

=AES CBC模式
	在相同的key和iv下，该程序和java程序加密的文件的md5值不同，但是java加密的文件，可以通过perl解密出来。
	@TODO 搞不懂为什么？
=cut
sub encryptFile{
	my $key = "1234567890abcdef";
	my $algorithm = "Rijndael";
	my $iv = "abcdef0123456789" ;
	my $sourceFile = "/Users/mac/Documents/data/bactive/MiLib114_S3_L001_R1_001.fastq.gz";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz.aes" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $cipher = Crypt::CBC->new(
			-key => $key,
			-cipher => $algorithm,
			-iv => $iv,
			-header => "none",
			-padding => "standard"
		);
	$cipher->start('encrypting');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->crypt($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

sub decryptFile{
	my $key = "1234567890abcdef";
	my $algorithm = "Rijndael";
	my $iv = "abcdef0123456789" ;
	my $sourceFile = "/Users/mac/Documents/data/bactive/005.fastq.gz.aes";
	my $destFile = "/Users/mac/Documents/data/bactive/004.fastq.gz" ;
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$destFile") or die "文件无法打开, $!";
	binmode(DATA2);

	my $cipher = Crypt::CBC->new(
			-key => $key,
			-cipher => $algorithm,
			-iv => $iv,
			-header => "none",
			-padding => "standard"
		);
	$cipher->start('decrypting');
	my $buffer = undef;
	my $buffer_size = 64*1024;
	while (read(DATA1,$buffer,$buffer_size)) {
		print DATA2 $cipher->crypt($buffer);
	}
	print DATA2 $cipher->finish();
	close(DATA1);
	close(DATA2);
}

#encryptString();
encryptFile();
#decryptFile();