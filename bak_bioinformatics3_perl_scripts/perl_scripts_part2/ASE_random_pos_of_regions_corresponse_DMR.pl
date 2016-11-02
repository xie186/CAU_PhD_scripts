#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($region_ana, $dmr, $window) = @ARGV;

open REGION,$region_ana or die "$!";
my @hash_pos;
while(<REGION>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt;$i <= $end; ++$i){
        push @hash_pos, "$chr\t$i";
    }
}

my $rand_index = @hash_pos;

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $rand_nu = int(rand($rand_index));
    my ($chr_rand,$pos) = split(/\t/, $hash_pos[$rand_nu]);
    my $left = $pos - $window - (int (($end-$stt+1)/2));
       $left = 0 if $left < 0;
    my $righ = $pos + $window + (int (($end-$stt+1)/2));
    print "$chr_rand\t$left\t$righ\n"; 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <geno length> <DMR region> <width of window>
    we use this scripts to get the ASE density around the random selected position in the regions that we used to idetify pDMR or gDMR.
DIE
}
