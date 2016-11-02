#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($dms) = @ARGV;
open DMS,$dms or die "$!";
my $dms_num = 0;
my @all_sites;

#increase decrease
my ($DMS_in_stab, $DMS_in_var, $DMS_de_stab, $DMS_de_var) = (0,0,0,0);
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$jug) = split;
        if($jug eq "S"){
            if($diff > 0 ){
                $DMS_de_stab ++;
            }else{
                $DMS_in_stab ++;
            }
        }elsif($jug eq "V"){
            if($diff > 0 ){
                $DMS_de_var ++;
            }else{
                $DMS_in_var ++;
            }
        }
}

my $perc_stab_in = $DMS_in_stab / ($DMS_in_stab + $DMS_in_var);
my $perc_stab_de = $DMS_de_stab / ($DMS_de_stab + $DMS_de_var);
print <<STAT;
type	Increase	Decrease	Percentage_of_increase
DMS_in	$DMS_in_stab	$DMS_in_var	$perc_stab_in
DMS_de	$DMS_de_stab	$DMS_de_var	$perc_stab_de
STAT

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> 
DIE
}
