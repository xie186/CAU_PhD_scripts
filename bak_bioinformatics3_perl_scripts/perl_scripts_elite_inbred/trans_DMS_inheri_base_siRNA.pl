#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($trans_DMS, $inheri, $process) = @ARGV;
open DMS,$trans_DMS or die "$!";
my %DMS_type;
while(<DMS>){
    chomp;
#    chr1    289418904       289418904       87      4       27      15      0.956043956043956       0.642857142857143       0.313186813186813       5.92960898777518e-06    0.001367042     .       -1      -1      .       0
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval,$chr1,$stt1,$end1) = split;
    if($qval < 0.01 && $stt1 != -1){
        $DMS_type{"$chr\t$stt"} = "Y";
    }elsif($qval < 0.01 && $stt1 == -1){
        $DMS_type{"$chr\t$stt"} = "N";
    }else{

    }
}

open INHER,$inheri or die "$!";
my ($tDMS_siRNA_stable, $tDMS_siRNA_var) = (0,0);
my ($tDMS_NOsiRNA_stable, $tDMS_NOsiRNA_var) = (0,0);
while(<INHER>){
    chomp;
    my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval) = split;
    if(exists $DMS_type{"$chr\t$stt"} && $DMS_type{"$chr\t$stt"} eq "Y"){
        if($qval >=0.01){
            ++$tDMS_siRNA_stable;
        }else{
            ++$tDMS_siRNA_var;
        }
    }elsif(exists $DMS_type{"$chr\t$stt"} && $DMS_type{"$chr\t$stt"} eq "N"){
        if($qval >=0.01){
            ++$tDMS_NOsiRNA_stable;
        }else{
            ++$tDMS_NOsiRNA_var;
        }
    }
}

print <<OUT;
$process	# of stable sites	# of variable sites
tDMS_siRNA	$tDMS_siRNA_stable	$tDMS_siRNA_var
tDMS_NOsiRNA	$tDMS_NOsiRNA_stable	$tDMS_NOsiRNA_var
OUT
sub usage{
    my $die = <<DIE;
    perl *.pl <trans_DMS> <inheritance judgement>
DIE
}
