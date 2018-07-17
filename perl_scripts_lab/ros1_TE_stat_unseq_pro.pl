#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($te_reg, $lap_reg, $eco_list) = @ARGV;

my %stat_eco;
open UN, $eco_list or die "$!";
while(<UN>){
    chomp;
    next if /#/;
    my ($eco) = split;
    $stat_eco{$eco} ++;
}
close UN;

my %te_pos;
open TE, $te_reg or die "$!";
while(<TE>){
    chomp;
    next if /^#/;
    my ($chr, $stt,$end) = split;
    for(my $i = $stt; $i <= $end; ++$i){
        $te_pos{"$i"} = keys %stat_eco;
    }
}
close TE;

open LAP, $lap_reg or die "$!";
while(<LAP>){
    chomp;
    my ($chr,$stt,$end,$eco) = split;
    next if !exists $stat_eco{$eco};
    for(my $i = $stt; $i <= $end; ++$i){
        $te_pos{"$i"} -- if exists $te_pos{"$i"};
    }
}
close LAP;

foreach(keys %te_pos){
    print "$_\t$te_pos{$_}\n";
}

sub usage{
    my $die =<<DIE;
perl $0  <te_reg> <lap_reg> <eco list>
DIE
}
