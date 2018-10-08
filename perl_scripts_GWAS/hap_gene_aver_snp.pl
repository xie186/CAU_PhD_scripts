#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($ge_pos,$map,$out) =@ARGV;

open MAP,$map or die "$!";
open OUT,"+>$out" or die "$!";
my %snp_pos;
while(<MAP>){
    chomp;
    my ($chr,$nu,$pos) = split;
    $chr = "chr".$chr if $chr =~ /^\d/;
    $snp_pos{"$chr\t$pos"} ++;
}

open POS,$ge_pos or die "$!";
my %hash_snp_nu;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    next if ($end-$stt > 10000 || $end-$stt<500); 
    $chr = "chr".$chr if $chr =~ /^\d/;
    next if $chr !~ /chr\d+/;
    for(my $i = $stt; $i<=$end; ++$i){
        $hash_snp_nu{$gene} ++ if exists $snp_pos{"$chr\t$i"};
    }
}

foreach(keys %hash_snp_nu){
    $hash_snp_nu{$_} = 0 if !exists $hash_snp_nu{$_};
    print OUT "$_\t$hash_snp_nu{$_}\n"
}

sub usage{
    my $die=<<DIE;
    print *.pl <Candidate gene pos> <MAP> <OUT>
DIE
}
