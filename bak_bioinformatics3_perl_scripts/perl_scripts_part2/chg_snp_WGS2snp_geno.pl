#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($gene_pos,$snp) = @ARGV;
open POS,$gene_pos or die "$!";
my %hash_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $hash_pos{$gene} = "$chr\t$stt\t$end\t$strand";
}

open SNP,$snp or die "$!";
while(<SNP>){
    chomp;
    my ($gene,$pos) = split;
    my ($chr,$stt,$end,$strand) = split(/\t/,$hash_pos{$gene});
    if($strand eq "+"){
        $pos = $stt + $pos - 1;
    }else{
        $pos = $end - $pos + 1;
    }
    $chr = "chr".$chr if $chr !~ /chr/;
    print "$chr\t$pos\t$gene\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <gene postion> <snp in WGS> 
DIE
}
