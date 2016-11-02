#!/usr/bin/perl -w
use strict;
my ($geno,$region)=@ARGV;
die usage() unless @ARGV==2;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
   @aa=split(/>/,$join);
$join=@aa; #chromosome number
my %hash;
for(my $i=1;$i<=$join;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $hash{$chr}=$tem_seq;
}

my ($chr,$stt,$end) = $region =~ /(chr\d+):(\d+)-(\d+)/;
my $tem_seq = substr($hash{$chr},$stt-1,$end-$stt+1);
    print ">lnc\_$chr\_$stt\_$end\n$tem_seq\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <Genome seq> <region chr1:100-1000>
DIE
}
