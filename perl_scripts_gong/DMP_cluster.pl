#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($ara_len,$fish) =@ARGV;
open FISH,$fish or die "$!";
my %hash_site;
while(<FISH>){
    chomp;
    my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split;
    next if $p_value >= 0.01;
    $hash_site{"$chr\t$pos"} ++;
}
open LEN,$ara_len or die "$!";
my %hash_region;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    next if $chr !~ /chr\d/;
    my $nu = int( $len / 1000) + 1;
    for(my $i = 1; $i <= $nu; ++$i){
        my ($stt,$end) = ( ($i-1)*1000 + 1, ($i-1)*1000 + 1000 );
        for(my $j = $stt; $j <= $end ; ++ $j){
            push @{$hash_region{"$chr\t$stt"}}, $j if exists $hash_site{"$chr\t$j"};
        }
    }    
}
#my %hash_chr;
foreach(keys %hash_region){
    my $nu = @{$hash_region{$_}};
    next if $nu < 5;
    my ($chr,$stt) = split(/\t/,$_); 
    my $end = $stt + 1000;
    my ($stt1,$end1) = (sort{$a<=>$b} @{$hash_region{"$chr\t$stt"}})[0,-1];
#    push @{$hash_chr{$chr}},($stt1,$end1);
    print "$chr\t$stt\t$end\t$stt1\t$end1\n";
}


sub usage{
    my $die = <<DIE;
    perl *.pl  <Ara length> <Fisher results> 
DIE
}
