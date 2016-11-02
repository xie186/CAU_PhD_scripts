#!/usr/bin/perl -w
use strict;
my ($bin_r2,$r2_cut) = @ARGV;
open BIN,$bin_r2 or die "$!";
my %hash_r2;
my %hash_bin;
while(<BIN>){
    chomp;
    my ($chr,$stt,$end,$bin,$r2)  = split;
    $hash_r2{"$chr\t$stt\t$bin"} = $r2;
    push @{$hash_bin{"$chr\t$stt"}} , $bin;
}

foreach my $coor(keys %hash_bin){
    my @bin = @{$hash_bin{$coor}};
    for(my $i = 0;$i<=$#bin;++$i){
        my ($flag1,$flag2) = (0,0);
        for(my $j=$i;$j<=$i+9;++$j){
            last if !$bin[$j];
            if($j == $i && $hash_r2{"$coor\t$bin[$j]"} >= $r2_cut){
                ++$flag1;
            }
            if($j > $i && $hash_r2{"$coor\t$bin[$j]"} >= $r2_cut){
                ++$flag2;
            }
        }
        if($flag1 ==1 && $flag2 == 0){
            print "$coor\t$bin[$i]\n";
            last;
        }else{
#            print "$coor\t$bin[$i]\t$flag1\t$flag2\n";
        }
 
    }
}
