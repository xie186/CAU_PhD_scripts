#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($cmp_2par, $progeny) = @ARGV;
open PAR,$cmp_2par or die "$!";
my %hash_pos;
while(<PAR>){
    chomp;
#    chr5    48837119        48837119        52      6       0       15      0.896551724137931       0       0.896551724137931      3.73133516975168e-11             3.416953e-08 
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    if($qval < 0.01){
        $hash_pos{"$chr\t$stt\t$end"} = "Y";
    }else{
        $hash_pos{"$chr\t$stt\t$end"} = "N";
    }   
}

open OFF,$progeny or die "$!";
while(<OFF>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    next if !exists  $hash_pos{"$chr\t$stt\t$end"};
    print "$_\t$hash_pos{\"$chr\t$stt\t$end\"}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <comparison two parents> <comparison parent and offspring> 
DIE
}
