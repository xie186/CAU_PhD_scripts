#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==4;
my ($dms, $genet_var,$win, $out)= @ARGV;
open VAR,$genet_var or die "$!";
my %snp_pos;
while(<VAR>){
    chomp;
    my ($chr,$pos,$geno1,$geno2) = split;
    $snp_pos{"$chr\t$pos"} ++ if $geno1 eq $geno2;
} 
close VAR;

open DMS,$dms or die "$!";
open OUT, "+>$out" or die "$!";
my ($tot_DMS, $tot_DMS_var) = (0,0);
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval) = split;
    next if $qval >= 0.01;
    my $snp_number = 0;
    for(my $i = $stt - $win; $i < $end + $win; ++$i){
        $snp_number ++ if exists $snp_pos{"$chr\t$i"}
    }
    $tot_DMS_var ++ if $snp_number > 0;
    $tot_DMS ++;
    print OUT "$chr\t$stt\t$snp_number\n";
}
close OUT;
close DMS;

print "$out\t$tot_DMS_var\t$tot_DMS\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <dms> <genetic variation> <windows> 
DIE
}
