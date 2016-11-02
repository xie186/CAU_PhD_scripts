#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($dms, $context, $cutoff) = @ARGV;

print "context\tpDMSs\tPercentage\tsDMSs\tPercentage\n";
my @dms = split(/,/, $dms);
my @context = split(/,/, $context);
for(my $i = 0; $i < @dms; ++$i){
    #increase decrease
    my ($pDMS, $sDMS, $dms_num) = (0,0, 0);
    open DMS, $dms[$i] or die "$!";
    while(<DMS>){
        chomp;
        my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$jug) = split;
        if($qval < $cutoff){
            if($jug eq "Y"){
                    $pDMS ++;
            }elsif($jug eq "N"){
                if($diff > 0 ){
                    $sDMS ++;
                }else{
                    $sDMS ++;
                }
            }
            ++ $dms_num;
        }
    }
    my $perc_pDMS = $pDMS / $dms_num;
    my $perc_sDMS = $sDMS / $dms_num;
    print "$context[$i]\t$pDMS\t$perc_pDMS\t$sDMS\t$perc_sDMS\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <context> <cutoff>
DIE
}
