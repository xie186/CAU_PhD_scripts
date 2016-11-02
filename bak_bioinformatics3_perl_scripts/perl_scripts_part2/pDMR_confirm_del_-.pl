#!/usr/bin/perl -w
use strict;
my ($geno)=@ARGV;
die usage() unless @ARGV == 1;
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
    $tem_seq =~ s/-//g;
    print ">$chr\n$tem_seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <seq> del the "-" in the sequence
DIE
}
