#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($inheri, $parent_diff) = @ARGV;

my %inher_stat;
open INHER,$inheri or die "$!";
while(<INHER>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval,$stat) = split;
    next if $qval >= 0.01;
    $inher_stat{"$chr\t$stt"} = $stat;
}

open DIFF,$parent_diff or die "$!";
my %stat_hash;
while(<DIFF>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval,$stat) = split;
    if(exists $inher_stat{"$chr\t$stt"}){
        if($stat eq "Y"){
            ${$stat_hash{$inher_stat{"$chr\t$stt"}}}[1] ++;
        }
        ${$stat_hash{$inher_stat{"$chr\t$stt"}}}[0] ++;
    }
}
close DIFF;

foreach(keys %stat_hash){
    print "$_\t${$stat_hash{$_}}[0]\t${$stat_hash{$_}}[1]\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <inheritance judgement> <parental diff jug>
DIE
}
