#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==3;
my ($snp, $win_size, $win_step) = @ARGV;
open SNP,$snp or die "$!";
my %hash_win478;
while(<SNP>){
    chomp;
    next if /x/i;
    #CHROM  POS     REF     Zheng58 5003    478     8112
    my ($chr,$pos,$ref,$zheng58,$in5003,$in478,$in8112) = split;
    next if $in5003 eq $in8112;
    push @{$hash_win478{$chr}}, "$pos,$zheng58,$in5003,$in478,$in8112";
}

foreach my $chr (keys %hash_win478){
    my @snp = @{$hash_win478{$chr}};
    my $snp_num = @snp;
    my $win_num = int (($snp_num - $win_size) / $win_step);
    
    for(my $i = 0;$i <= $win_num; ++$i){
       my $win_8112_478     = 0;
       my $win_8112_zheng58 = 0;
       my @pos;
       for(my $j = 0; $j < $win_size; ++$j){
           my $index = $i * $win_step + $j;   ### SNP index
           my ($pos,$zheng58,$in5003,$in478,$in8112) = split(/,/, ${$hash_win478{$chr}}[$index]);
           $win_8112_478 ++ if $in8112 eq $in478;
           $win_8112_zheng58 ++ if $in8112 eq $zheng58;
           push @pos, $pos;
       }
       my $snp_num = @pos;
       my $win_8112_478_perc = $win_8112_478 / $snp_num;
       my $win_8112_zheng58_perc = $win_8112_zheng58 / $snp_num;
       print "$chr\t$pos[0]\t$pos[-1]\t$win_8112_478_perc\t$win_8112_zheng58_perc\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <SNP> <windows size> <windows step>
DIE
}
