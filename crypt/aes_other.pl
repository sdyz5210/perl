#! /usr/bin/perl

use strict;
use Crypt::ECB;
use MIME::Base64;
use warnings;
use Crypt::CBC;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);

sub testBase64{
	my $result = "Hello world!";
	print encode_base64($result);
}

sub testEcb{
	my $ecb = Crypt::ECB->new;
	$ecb->cipher('AES');
	$ecb->key('1234567890abcdef'); 
	 
	my $enc = $ecb->encrypt("Hello World!!!");
	print encode_base64($enc);
	my $result = $ecb->decrypt($enc);
	print("$result\n");
}

sub testAes_Cbc {
	my $plainText = "secret stuff goes here...";
	my $id = "aabb-1234";
	my $iv = substr(md5_hex($id), 0, 16);
	my $cipher = Crypt::CBC->new(
		-key         => 'd2cb415e067c7b13',
		-iv          => $iv,
		-cipher      => 'OpenSSL::AES',
		-literal_key => 1,
		-header      => "none",
		-padding     => "standard",
		-keysize     => 16
	  );
	my $encrypted = $cipher->encrypt($plainText);
	my $base64 = encode_base64($encrypted);
	print("Ciphertext(b64):$base64\n");
}

testEcb();