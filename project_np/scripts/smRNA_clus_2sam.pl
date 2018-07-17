#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($rep,  $cut) = @ARGV;

my %rec_rep;
my %rec_clus;
my @rep = split(/,/, $rep);
foreach my $rep1(@rep){
    open REP1, $rep1 or die "$!";
    while(<REP1>){
        chomp;
        my ($chr, $stt, $end, $non_iden, $iden, $p_val) = split;
        push @{$rec_rep{"$chr\t$stt\t$end"}}, $non_iden;
        if($p_val < $cut){
	    $rec_clus{"$chr\t$stt\t$end"} ++;
        }
    }
    close REP1;
}

foreach(keys %rec_clus){
    my @iden = @{$rec_rep{$_}};
    #my $aver = ($iden[0] + $iden[1])/2;
    print "$_\t$iden[0]\t$iden[1]\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <rep1,rep2> <cut>
DIE
} 
