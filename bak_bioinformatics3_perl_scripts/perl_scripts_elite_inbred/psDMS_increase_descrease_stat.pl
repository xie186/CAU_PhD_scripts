#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dms, $cutoff) = @ARGV;
open DMS,$dms or die "$!";
my $dms_num = 0;
my @all_sites;

#increase decrease
my ($pDMS_in, $pDMS_de, $sDMS_in, $sDMS_de) = (0,0,0,0);
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$jug) = split;
    if($qval < $cutoff){
        if($jug eq "Y"){
            if($diff > 0 ){
                $pDMS_de ++;
            }else{
                $pDMS_in ++;
            }
        }elsif($jug eq "N"){
            if($diff > 0 ){
                $sDMS_de ++;
            }else{
                $sDMS_in ++;
            }
        }
        ++ $dms_num;
    }
    push @all_sites, "$chr\t$stt\t$end\tRandom";
}

my $perc_pDMS = $pDMS_in / ($pDMS_in + $pDMS_de);
my $perc_sDMS = $sDMS_in / ($sDMS_in + $sDMS_de);
print <<STAT;
type	Increase	Decrease	Percentage_of_increase
pDMS	$pDMS_in	$pDMS_de	$perc_pDMS
sDMS    $sDMS_in        $sDMS_de	$perc_sDMS
STAT

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <cutoff>
DIE
}
