#!/usr/bin/perl -w
use strict;

die("Usage:perl *.pl <genome><trans>\n") unless @ARGV==2;

open GENO,$ARGV[0] or die;
my @aa=<GENO>;
my $seq=join('',@aa);
@aa=(split(/>/,$seq));
my %hash;
foreach(@aa){
    my @ss=split(/\n/,$_);
    chomp @ss;
    my $chr=shift @ss;
    my $seq=join('',@ss);
    $hash{$chr}=$seq if (defined $chr);
}

open TRAN,$ARGV[1] or die;
while(<TRAN>){
    chomp $_ ;
    my @cc=(split(/\s+/,$_))[0,-1,-2,-3,-4];
    my $chrsnp=shift @cc;
    @cc=sort{$a<=>$b}@cc;
    my $transeq=substr($hash{$chrsnp},$cc[0]-1,$cc[-1]-$cc[0]+1);
    print ">IES_$chrsnp","_$cc[0]_$cc[-1]\n$transeq\n";
}
