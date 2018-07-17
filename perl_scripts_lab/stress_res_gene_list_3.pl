#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($rarge, $drastic, $geo, $out) = @ARGV;

my %rec_gene;
open RAR, $rarge or die "$!";
while(<RAR>){
    chomp;
    my ($id, $stress, $up_down) = split(/\t/);
    $id = uc $id;
    $stress =~ s/\s+/_/g;
    $rec_gene{$id} -> {"RARGE:$stress-$up_down"} ++;
}
close RAR;

open DRA, $drastic or die "$!";
while(<DRA>){
    chomp;
    my ($id, $stress, $up_down) = split(/\t/);
    $id = uc $id;
    $stress =~ s/\s+/_/g;
    $rec_gene{$id} -> {"DRASTIC:$stress-$up_down"} ++;
}
close DRA;

open GEO, $geo or die "$!";
while(<GEO>){
    chomp;
    my ($id, $type) = split(/\t/);
    $rec_gene{$id} -> {$type} ++;
}

open OUT, "+>$out" or die "$!";
foreach(keys %rec_gene){
    chomp;
    my $info = join(";", keys %{$rec_gene{$_}});
    print OUT "$_\t$info\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
perl $0 <RARGE> <DRASTIC> <GEO> <OUT> 
DIE
}
