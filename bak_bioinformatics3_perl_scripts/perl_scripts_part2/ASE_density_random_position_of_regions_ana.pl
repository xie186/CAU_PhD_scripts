#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($imp_pos,$region_ana,$window) = @ARGV;

open F,$imp_pos or die "$!";
my %hash_imp;
while(<F>) {
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    my $mid=int (($stt+$end)/2);
    $hash_imp{"$chr\t$mid"}++;
}

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
     my $righ = $pos + $window;
     my $count = 0;
     for(my $i = $left; $i <= $righ; $i++){
#          print "$chr_rand\t$i\n";
          if(exists $hash_imp{"$chr_rand\t$i"}) {
              $count++;
          }
     }
     print "chr$chr_rand\t$pos\t$count\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <imp pos> <geno length> <width of window>
    we use this scripts to get the ASE density around the random selected position in the regions that we used to idetify pDMR or gDMR.
DIE
}
