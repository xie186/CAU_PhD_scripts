#!/use/bin/perl -w
use strict;

my ($geno,$name)=@ARGV;

open GENO,$geno or die "$!";
my @tem=<GENO>;
my $join=join'',@tem;
   @tem=split(/>/,$join);
   $join="";

open NAME,$name or die "$!";
while(<NAME>){
    chomp;
    my ($chr,$stt,$end)=$_=~/^IES_(chr\d+)_(\d+)_(\d+)/;
 
}
