#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($rep,  $cut) = @ARGV;

my %rec_rep;

my @rep = split(/,/, $rep);
foreach my $rep1(@rep){
    open REP1, $rep1 or die "$!";
    while(<REP1>){
        chomp;
        my ($chr, $stt, $end, $non_iden, $iden, $p_val) = split;
        push @{$rec_rep{"$chr\t$stt\t$end"}}, $non_iden if $p_val < $cut;
    }
    close REP1;
}

foreach(keys %rec_rep){
    my @iden = @{$rec_rep{$_}};
    next if @iden < @rep;
    my $aver = ($iden[0] + $iden[1])/2;
    print "$_\t$aver\n";
}

sub usage{
    my $die =<<DIE;
pelr *.pl <rep1,rep2> <cut>
DIE
} 
