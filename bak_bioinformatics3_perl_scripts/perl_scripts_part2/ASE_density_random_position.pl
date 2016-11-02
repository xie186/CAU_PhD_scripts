#!/usr/bin/perl -w
use strict;
#perl DMR_gene_density.pl <ZmB73_5b_FGS_gene_half> <DMR_region>
die usage() unless @ARGV == 3;
my ($imp_pos,$geno_len,$window) = @ARGV;

open F,$imp_pos or die "$!";
my %hash_imp;
while(<F>) {
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    my $mid=int (($stt+$end)/2);
    $hash_imp{"$chr\t$mid"}++;
}

open LEN,$geno_len or die "$!";
my %hash_chr;
while(<LEN>){
    chomp;
    my ($chr,$length) = split;
       $hash_chr{$chr} = $length;
}

for(my $i = 1;$i <= 10000;++ $i){
     my $chr_rand = int(rand(10)) + 1;
     my $chr_len = $hash_chr{"chr$chr_rand"};
     my $len = int(rand($chr_len)) + 1;
     my $left = $len - $window;
     my $righ = $len + $window;
     my $count = 0;
     for(my $i = $left; $i <= $righ; $i++){
#          print "$chr_rand\t$i\n";
          if(exists $hash_imp{"chr$chr_rand\t$i"}) {
              $count++;
          }
     }
     print "chr$chr_rand\t$len\t$count\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <imp pos> <geno length> <width of window>
    we use this scripts to get the ASE density around the random selected position
DIE
}
