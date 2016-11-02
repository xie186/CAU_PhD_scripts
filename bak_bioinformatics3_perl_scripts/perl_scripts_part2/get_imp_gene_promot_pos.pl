#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($name, $ge_pos, $promot_dis) = @ARGV;
open POS,$ge_pos or die "$!";
my %hash_pos;
while(<POS>){
    next if /^UN/;
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    my ($promot_stt, $promot_end) = (0, 0);
    if($strand eq "+"){
        ($promot_stt, $promot_end) = ($stt - 10000, $stt);
        $promot_stt = 0 if $promot_stt < 0;
    }else{
        ($promot_stt, $promot_end) = ($end, $end+10000);
    }
    
    $hash_pos{$gene} = "chr$chr\t$promot_stt\t$promot_end\t$gene-promoter$promot_dis\t$strand\n";
}
open NA,"cut -f1 $name|" or die "$!";
while(<NA>){
    chomp;
    print "$hash_pos{$_}" if exists $hash_pos{$_};
}


sub usage{
    my $die=<<DIE;
    perl *.pl <Name> <Gene position> <promoter regions>
DIE
}
