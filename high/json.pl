#! /usr/bin/perl

use strict;
use Encode;
use JSON;
use Data::Dumper;

my $json = new JSON;
my $json_obj;
my $username;
my $age;
my $email;
my $temp;

open(DATA1,"test.json") or die "文件无法打开, $!";
while (<DATA1>) {
	$temp .= $_;
}

$json_obj = $json->decode($temp);

$username = $json_obj->{'username'};
$age = $json_obj->{'age'};
$email = $json_obj->{'email'};

print $username,$age,$email;