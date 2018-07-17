#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($wt, $mut) = @ARGV;

open WT, $wt or die "$!";
my %rec_wt_exp;
while(my $line = <WT>){
    chomp $line;
    my ($chr, $stt, $end, $exp) = split(/\t/, $line);
    $rec_wt_exp{"$chr\t$stt\t$end"} = $exp;
}
close WT;

open MUT, $mut or die "$!";
while(<MUT>){
    chomp;
    my ($chr, $stt, $end, $non_identical_reads) = split;
    if(exists $rec_wt_exp{"$chr\t$stt\t$end"}){
        my $wt_exp = $rec_wt_exp{"$chr\t$stt\t$end"};
        print "$chr\t$stt\t$end\t$wt_exp\t$non_identical_reads\n";
    }
}
close MUT;

sub usage{
    my $die =<<DIE;
perl *.pl <wtt stat> <mut stat> 
DIE
}


