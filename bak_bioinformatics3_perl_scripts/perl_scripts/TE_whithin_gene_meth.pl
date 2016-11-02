#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($repeat,$bed)=@ARGV;
open RE,$repeat or die "$!";
my %re_pos;
while(<RE>){
    chomp;
    my ($chr,$stt,$end)=(split(/\s+/,$_))[-5,-4,-3];
    #print "$chr,$stt,$end\n";
    for(my $i=$stt-4000;$i<=$end+4000;++$i){
        $re_pos{"chr$chr\t$i"}++;
    }
}
close RE;

open BED,$bed or die "$!";
my %meth;
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$lev)=split;
    if(exists $re_pos{"$chr\t$stt"}){
        delete $re_pos{"$chr\t$stt"};
        $meth{"$chr\t$stt"}=$lev;
    }
}

open RE,$repeat or die "$!";
while(<RE>){
    chomp;
    my ($chr,$stt,$end)=(split)[-5,-4,-3,-2,-1];
    my ($report,$meth)=(0,0);
    for(my $i=$stt-2;$i<=$end+2;++$i){
        if(exists $meth{"chr$chr\t$i"}){
            $meth=$meth{"chr$chr\t$i"};
            $report++;
        }
    }
    if($report<3){
        print "$_\tNA\n";
    }else{
        my $lev=$meth/$report;
        print "$_\t$lev\n";
    }
}
sub usage{
    my $die=<<DIE;

USAGE:perl *.pl <Repeats with RPKM> <Bedgraph File> >>OUTPUT
We use this to calculate the methylation level of repeats whithin gene 

DIE
}
