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

=key
	DER：JAVA默认使用的格式
	PEM：PEM文件是Base64编码的证书。PEM是OpenSSL和许多其他SSL工具的标准格式，OpenSSL使用PEM文件格式存储证书和密钥。

	注意：此处生成的pem及der文件，使用java语言没办法识别，暂时没有找到perl在这方便的配置和修改。原因是生成的pem没有转换成pkcs8格式

	使用openssl生成pem或der可以，如下
	openssl genrsa -out rsakey.priv.pem 1024
	openssl pkcs8 -topk8 -inform PEM -outform DER -in rsakey.priv.pem -out rsakey.priv.der -nocrypt
	openssl rsa -in rsakey.priv.pem -pubout -outform DER -out rsakey.pub.der
=cut
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

sub decryptStringFromJava{
	my $pkrsa = Crypt::PK::RSA->new;
	$pkrsa->import_key("rsakey.pub.der");
	$pkrsa->import_key("rsakey.priv.der");

	my $str_en = 'FIAJ8iCgbDU9sJUHrsAoUt9h+lG4GJ4geoBK8ePR4ovsrd9GhbP/cH8+ayscgaYlccnIIbPGA233vW9nRQ4iWVYwAd3jTfik8BvO1r3PFgYpWJn1jXNZ68B9UrrgiOyN8O1xyxM3j0rt8camFACbVQwc5twBWOcuqpaykm83jL0=';
	my $str_de = $pkrsa->decrypt(decode_base64($str_en));
	print $str_de;
}

#encryptString();
saveKey();
#encryptStringImportKey();
#decryptStringFromJava();