#!/usr/bin/perl -w
use strict;
my ($geno,$dmr,$min_cut,$max_cut)=@ARGV;
die usage() unless @ARGV == 4;
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

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp; 
    my ($chr,$stt,$end,$context) = split;
    my $mid = int (($stt + $end)/2);
#    next if ($end - $stt + 1 > $max_cut || $end - $stt + 1 < $min_cut);
    my $tem_seq = substr($hash{$chr},$mid-4000,8000);
    print ">region\_$chr\_$stt\_$end\_$context\n$tem_seq\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Genome seq> <DMR region> <Mini length> <Max length>
DIE
}
