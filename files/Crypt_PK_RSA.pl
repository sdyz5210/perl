#! /usr/bin/perl

use strict;
use Crypt::PK::RSA;
use File::Slurp 'write_file';
use MIME::Base64;

sub encryptString {
	my $pk = Crypt::PK::RSA->new();
	$pk->generate_key(128, 65537);
	my $private_der = $pk->export_key_der('private');
	my $public_der = $pk->export_key_der('public');
	my $str = "Hello World!!!";
	my $str_en = $pk->encrypt($str);
	print encode_base64($str_en);
	print "\n";
	my $str_de = $pk->decrypt($str_en);
	print $str_de;
}

sub saveKey{
	my $pk = Crypt::PK::RSA->new();
	$pk->generate_key(128, 65537);
	write_file("rsakey.pub.der",  {binmode=>':raw'}, $pk->export_key_der('public'));
	write_file("rsakey.priv.der", {binmode=>':raw'}, $pk->export_key_der('private'));
	write_file("rsakey.pub.pem",  $pk->export_key_pem('public_x509'));
	write_file("rsakey.priv.pem", $pk->export_key_pem('private'));
	write_file("rsakey-passwd.priv.pem", $pk->export_key_pem('private', 'secret'));
}

sub encryptStringImportKey {
	my $pkrsa = Crypt::PK::RSA->new;
	$pkrsa->import_key("rsakey.pub.der");
	$pkrsa->import_key("rsakey.priv.der");

	my $str = "Hello World!!!";
	my $str_en = $pkrsa->encrypt($str);
	print encode_base64($str_en);
	print "\n";
	my $str_de = $pkrsa->decrypt($str_en);
	print $str_de;
}

#encryptString();
saveKey();
#encryptStringImportKey();