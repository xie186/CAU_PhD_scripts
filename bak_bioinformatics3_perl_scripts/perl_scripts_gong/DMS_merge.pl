#!/usr/bin/perl -w
use strict;

my ($dms) = @ARGV;

my %hash_dms;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value,$lev1,$lev2) = split;
    push @{$hash_dms{$chr}},$pos;
}

foreach my $chr (keys $hash_dms){
    my @tem_pos = sort{$a<=>$b}@{$hash_dms{$chr}};
    my $nu =  @tem_pos;
    my ($stt,$end) = ($tem_pos[$i] , 0);
    for(my $i = 0 ;$i < $nu - 1 ; ++$i){
        if($tem_pos[$i+1] - $tem_pos[$i] <=100){
            ($stt,$end) = ($tem_pos[$i], $tem_pos[$i+1]);
        }else{
            if($end > $stt){
                print "$chr\t$stt\t$end\n";
             }
             ($stt,$end) = ($tem_pos[$i+1],0);
             $i += 2;
        }
    }
}
