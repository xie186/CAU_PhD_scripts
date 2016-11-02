#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($trans_DMS, $inheri, $out) = @ARGV;

my %site_for_jug;
open INHER,$inheri or die "$!";
while(<INHER>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval) = split;
        if($qval >=0.01){
            $site_for_jug{"$chr\t$stt"} = "S";
        }else{
            $site_for_jug{"$chr\t$stt"} = "V";
        }
}


open DMS,$trans_DMS or die "$!";
open OUT, "+>$out" or die "$!";
my %DMS_type;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval) = split;
    next if $qval >= 0.01;
    if(exists $site_for_jug{"$chr\t$stt"}){
        print OUT "$_\t$site_for_jug{\"$chr\t$stt\"}\n";
    }
}
close OUT;
close DMS;
#print <<OUT;
#$process	# of stable sites	# of variable sites
#tDMS_siRNA	$tDMS_siRNA_stable	$tDMS_siRNA_var
#tDMS_NOsiRNA	$tDMS_NOsiRNA_stable	$tDMS_NOsiRNA_var
#OUT
sub usage{
    my $die = <<DIE;
    perl *.pl <trans_DMS> <inheritance judgement> <OUT>
DIE
}
