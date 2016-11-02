#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($region_ana,$window) = @ARGV;

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
for(my $i = 1;$i <= 10000;++ $i){
     my $rand_nu = int(rand($rand_index));
     my ($chr_rand,$pos) = split(/\t/, $hash_pos[$rand_nu]);
     my $left = $pos - $window;
        $left = 0 if $left < 0;
     my $righ = $pos + $window;
     print "$chr_rand\t$left\t$righ\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <geno length> <width of window>
    we use this scripts to get the ASE density around the random selected position in the regions that we used to idetify pDMR or gDMR.
DIE
}
