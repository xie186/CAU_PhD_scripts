#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($parent_stat, $inheri, $out_pDMS, $out_sDMS) = @ARGV;

my ($pDMS_tot,$pDMS_stab, $sDMS_tot,$sDMS_stab) = (0,0,0,0);
open STAT,$parent_stat or die "$!";
my %par_stat;
while(<STAT>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval, $stat) = split;
    next if $qval >= 0.01;
    $par_stat{"$chr\t$stt\t$end"} = $stat;
}

open OUTP,"+>$out_pDMS" or die "$!";
open OUTS,"+>$out_sDMS" or die "$!";
open INHER,$inheri or die "$!";
while(<INHER>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval, $stat) = split;
    next if !exists $par_stat{"$chr\t$stt\t$end"};
    if($par_stat{"$chr\t$stt\t$end"} eq "Y"){
        print OUTP "$_\n";
        ++ $pDMS_tot;
        ++ $pDMS_stab if $stat eq "S";
    }else{
        print OUTS "$_\n";
        ++ $sDMS_tot;
        ++ $sDMS_stab if $stat eq "S";
    }
}

my ($pDMS_perc, $sDMS_perc) = ($pDMS_stab/$pDMS_tot, $sDMS_stab/$sDMS_tot);
print "$pDMS_tot\t$pDMS_stab\t$pDMS_perc\t$sDMS_tot\t$sDMS_stab\t$sDMS_perc\n";

sub usage{
    my $die = <<DIE;
    perl *.pl <parent_stat> <inheritance judgement> <OUT pDMS> <OUT sDMS>
DIE
}
