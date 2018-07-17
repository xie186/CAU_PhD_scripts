#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($dmr, $ge_pos, $out)=@ARGV;
my $BIN = 60;

my %meth_pos;
open BED,$dmr or die "$!";
while(<BED>){
    chomp;
    my ($chrom,$pos1,$pos2) = split;
        $chrom =~ s/Chr/chr/g;
    my $mid = int (($pos1+$pos2) /2);
    $meth_pos{"$chrom\t$mid"} ++;
}
close BED;

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die "$!";
my %meth_forw;
my $flag=1;
my %region;
    while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, $chr, $i);
            }
        }
        $region{"flank"} += 2000/100;
        $region{"body"} += ($end - $stt +1) / $BIN;
    }

foreach(sort keys %meth_forw){
    my $num_DMR_per1M = $meth_forw{$_}*1000000 / $region{"flank"} if ($_=~/prom/ || $_=~/term/);
    $num_DMR_per1M = $meth_forw{$_}*1000000 / $region{"body"} if ($_=~/body/);
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$num_DMR_per1M\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$chr,$pos) = @_;
    my $unit=($end-$stt+1)/($BIN - 0.01);
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    $meth_forw{$keys} ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <Gene position> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
