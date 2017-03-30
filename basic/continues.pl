#/usr/bin/perl

$a = 0;
while($a < 3){
	print "a = $a\n";
}continue{
	$a = $a + 1;
}

@list = (1, 2, 3, 4, 5);
foreach $a (@list){
   print "b = $a\n";
}continue{
   last if $a == 4;
}

#Perl redo 语句直接转到循环体的第一行开始重复执行本次循环，redo语句之后的语句不再执行，continue语句块也不再执行。
$a = 0;
while($a < 10){
   if( $a == 5 ){
      $a = $a + 1;
      redo;
   }
   print "a = $a\n";
}continue{
   $a = $a + 1;
}