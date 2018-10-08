#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($win,$prefix,$surfix,$nu) = @ARGV;
my %ld_decay;
for my $chr_nu(1..$nu){
    open LD,$prefix.$chr_nu.$surfix or die "$!";
    while(<LD>){
        next if /CHR/;
        chomp;
        my ($chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq) = split;
        #print "$chr1,$pos1,$index1,$chr2,$pos2,$index2,$r_sq\n";
        my $win_nu = int (($pos2-$pos1+1)/$win) + 1;
        $ld_decay{$win_nu}[0] ++;
        $ld_decay{$win_nu}[1] += $r_sq;
    }
}
foreach(sort{$a<=>$b}keys %ld_decay){
    my $pos = $_*$win - $win/2;
    my $aver_ld = $ld_decay{$_}[1] / $ld_decay{$_}[0];
    print "$pos\t$aver_ld\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <window size> <LD res prefix> <LD res surfix [.ld]> <nu>
DIE
}
