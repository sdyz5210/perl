#!/usr/bin/perl

#last 相当于 break

$age=10;
while ($age<15) {
	$age = $age + 1;
	if ($age==13) {
		last;
	}
	print "$age\n";
}

#next 相当于continue
$age=10;
while ($age<15) {
	$age = $age + 1;
	if ($age==13) {
		next;
	}
	print "$age\n";
}