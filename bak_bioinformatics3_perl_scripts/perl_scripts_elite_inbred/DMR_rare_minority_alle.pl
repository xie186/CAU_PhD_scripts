#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($dmr) = @ARGV;

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    next if /^x/;
    my ($dmr_id, $chr,$stt,$end,$len,$nu_probe,$stat, @lev) = split;
    my $nu = @lev;
    my $low_stat =0;
    my $hi_stat = 0;
    for(my $i = 0;$i< $nu;++$i){
        if($lev[$i] < 0){
            $low_stat ++;
        }else{
            $hi_stat ++;
        }
    }
    if($hi_stat > $low_stat){
        print "$chr\t$stt\t$end\thypo\n";
    }else{
        print "$chr\t$stt\t$end\thyper\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMR> 
DIE
}
