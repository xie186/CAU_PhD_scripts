#!/usr/bin/perl -w

NONONO this has to be modified.
use strict;
die usage() unless @ARGV == 3;
my ($dms,$ge_pos,$out)=@ARGV;
my $BIN = 60;

my %dms_pos;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_bw_parents_jug) = split;
    @{$dms_pos{"$chr\t$stt"}} = ($qval, $dms_bw_parents_jug);
}

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my %count_dms;
while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $dms_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$dms_pos{"$chr\t$i"}});
            }
        }
}

foreach(sort keys %count_dms){
    my $aver_dms_num_per_1k_sites = ${$count_dms{$_}}[0] * 1000 / ${$count_dms{$_}}[1];
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$aver_dms_num_per_1k_sites\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$qval, $dms_bw_parents_jug) = @_;
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
    if($qval < 0.01 && $dms_bw_parents_jug eq "Y"){
        ${$count_dms{$keys}}[0] ++;
    }
    ${$count_dms{$keys}}[1] ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <qvalue results> <Gene position> <OUTPUT>
    This is to get DMSs distribution throughth gene
DIE
}
