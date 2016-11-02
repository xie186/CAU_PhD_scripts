#!/usr/bin/perl -w
use strict;
die("Usage:perl *.pl <genome><trans>\n") unless @ARGV==2;
open GENO,$ARGV[0] or die;
my @aa=<GENO>;
my $seq=join('',@aa);
$seq=~s/>//;
@aa=(split(/>/,$seq));
my %hash;
my $nu=@aa;
for(my $i=0;$i<$nu;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=(split(/\n/,$tem));
    my $seq=join('',@seq);
    $hash{$chr}=$seq;
}

open TRAN,$ARGV[1] or die;
while(<TRAN>){
    chomp;
    my @cc=(split(/\s+/,$_))[0,1,2];
    my $transeq=substr($hash{$cc[0]},$cc[1]-1,$cc[2]-$cc[1]+1);
    print ">IES_$cc[0]\_$cc[1]_$cc[2]\n$transeq\n";
}
