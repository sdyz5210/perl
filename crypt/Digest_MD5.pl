#! /usr/bin/perl

use strict;
use Digest::MD5 qw(md5 md5_hex md5_base64);

sub hashStrMd5 {
	my $message = "Hello World!!!";
	#my $digest = md5($message);
	#my $digest = md5_base64($message);
	my $digest = md5_hex($message);
	print "$digest";
}

sub hashStrMd5ByOO {
	my $message = "Hello World!!!";
	my $ctx = Digest::MD5->new;
	$ctx->add($message);
	#$digest = $ctx->digest;
 	my $digest = $ctx->hexdigest;
	#$digest = $ctx->b64digest;
	print "$digest";
}

sub hashFileMd5 {
	my $sourceFile = "/Users/mac/Documents/data/bactive/001.fastq.gz";
	open(DATA1,"<$sourceFile") or die "文件无法打开, $!";
	binmode(DATA1);
	my $ctx = Digest::MD5->new;
	my $buffer = undef;
	my $buffer_size = 64*1024;
	while (read(DATA1,$buffer,$buffer_size)) {
		$ctx->add($buffer);		
	}
	my $digest = $ctx->hexdigest;
	print "$digest";
}

hashFileMd5();