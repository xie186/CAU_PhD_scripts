#!/usr/bin/perl

open (SNP,$ARGV[0]) or die;
@aa=(asdfas,asdfgg,ddddd);
$j=4;
while (<SNP>){
     ($a,$v,$c)=split;
     print "$c\t$v\n" if $c>6;
     $j=8
}
print "$j\n";
