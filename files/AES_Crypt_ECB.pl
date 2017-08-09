#! /usr/bin/perl

use strict;
use Crypt::ECB;
use MIME::Base64;

sub testBase64{
	my $result = "Hello world!";
	print encode_base64($result);
}

sub testEcb{
	my $key = '1234567890abcdef';
	my $algorithm = "Rijndael";
	my $ecb = Crypt::ECB->new({
			cipher    => $algorithm,
			key       => $key,
	});

	my $enc = $ecb->encrypt("Hello World!!!");
	print encode_base64($enc);
	print $ecb->decrypt($enc);
}

=AES_EN
	实现了AES的ECB加密模式
=cut
sub testFileEncryptEcb{
	my $sourceFile = "/Users/mac/Documents/data/bactive/MiLib114_S3_L001_R1_001.fastq.gz";
	my $destFile = "/Users/mac/Documents/data/bactive/003.fastq.gz.aes" ;
	my $encoding = ":raw:perlio:bytes";
	open(DATA1,"<$encoding",$sourceFile) or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$encoding",$destFile) or die "文件无法打开, $!";
	binmode(DATA2);

	my $key = "1234567890abcdef";
	my $algorithm = "Rijndael";
	my $cipher = Crypt::ECB->new({
			cipher    => $algorithm,
			key       => $key,
			padding   => 'standard'
		});
	$cipher->start('encrypt');
	my $buff ;
	while (read(DATA1,$buff,64*1024)) {
		print DATA2 $cipher->crypt($buff);
	}
	print DATA2 $cipher->finish;
	close(DATA2);
	close(DATA1);
}

=AES_DE
	实现了AES的ECB的解密
=cut
sub testFileDecryptEcb{
	my $sourceFile = "/Users/mac/Documents/data/bactive/003.fastq.gz.aes";
	my $destFile = "/Users/mac/Documents/data/bactive/003.fastq.gz" ;
	my $encoding = ":raw:perlio:bytes";
	open(DATA1,"<$encoding",$sourceFile) or die "文件无法打开, $!";
	binmode(DATA1);
	open(DATA2,">$encoding",$destFile) or die "文件无法打开, $!";
	binmode(DATA2);

	my $key = "1234567890abcdef";
	my $algorithm = "Rijndael";
	my $cipher = Crypt::ECB->new({
			cipher    => $algorithm,
			key       => $key,
			padding   => 'standard'
		});
	$cipher->start('decrypt');
	my $buff ;
	while (read(DATA1,$buff,64*1024)) {
		print DATA2 $cipher->crypt($buff);
	}
	print DATA2 $cipher->finish;
	close(DATA2);
	close(DATA1);
}

#testBase64();
#testEcb();
#testFileEncryptEcb();
testFileDecryptEcb();
