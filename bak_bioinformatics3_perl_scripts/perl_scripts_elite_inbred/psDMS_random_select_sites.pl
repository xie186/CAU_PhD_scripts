#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dms, $cutoff) = @ARGV;
open DMS,$dms or die "$!";
my $dms_num = 0;
my @all_sites;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$jug) = split;
    if($qval < $cutoff){
        if($jug eq "Y"){
            print "$chr\t$stt\t$end\tpDMS\n";
        }elsif($jug eq "N"){
            print "$chr\t$stt\t$end\tsDMS\n";
        }
        ++ $dms_num;
    }
    push @all_sites, "$chr\t$stt\t$end\tRandom";
}

my $tot_num = @all_sites;
for(my $i = 0; $i < $dms_num; ++$i){
    my $rand = int(rand($tot_num)); 
    print "$all_sites[$rand]\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <cutoff>
DIE
}
