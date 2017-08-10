#! /usr/bin/perl

use strict;
use Crypt::PK::RSA;
use MIME::Base64;

sub encryptString {
	my $pk = Crypt::PK::RSA->new();
	$pk->generate_key(256, 65537);
	my $private_der = $pk->export_key_der('private');
	my $public_der = $pk->export_key_der('public');
	my $private_pem = $pk->export_key_pem('private');
	my $public_pem = $pk->export_key_pem('public');

	my $str = "Hello World!!!";
	my $str_en = $pk->encrypt($str);
	print encode_base64($str_en);
	print "\n";
	my $str_de = $pk->decrypt($str_en);
	print $str_de;
}

encryptString();