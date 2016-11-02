#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
my ($dms,$dms_type,$TE_pos_type,$TE_type,$out)=@ARGV;
my $BIN = 60;

open TYPE,$TE_type or die "$!";
my %type;
while(<TYPE>){
    chomp;
    $type{$_} ++;
}

my %dms_pos;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval, $dms_bw_parents_jug) = split;
    @{$dms_pos{"$chr\t$stt"}} = ($qval, $dms_bw_parents_jug);
}

open OUT,"|sort -k2,2n -k3,3n >$out" or die;
open POS,$TE_pos_type or die;
my %count_dms;
while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $strand , $name)=split(/\t/,$line);
        next if !exists $type{$name};
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $dms_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$dms_pos{"$chr\t$i"}},$name);
            }
        }
}
close POS;

foreach(sort keys %count_dms){
    ${$count_dms{$_}}[0] = 0 if (!${$count_dms{$_}}[0]);
    my $aver_dms_num_per_1k_sites = ${$count_dms{$_}}[0] * 1000 / ${$count_dms{$_}}[1];
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$aver_dms_num_per_1k_sites\n";
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1,$qval, $dms_bw_parents_jug, $type) = @_;
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
    $keys = "$type\t$keys";
    if($dms_type eq "DMS"){
       if($qval < 0.01){
           ${$count_dms{$keys}}[0] ++;
       }
    }elsif($dms_type eq "pDMS"){
       if($qval < 0.01 && $dms_bw_parents_jug eq "Y"){
          ${$count_dms{$keys}}[0] ++;
       }
    }elsif($dms_type eq "sDMS"){
       if($qval < 0.01 && $dms_bw_parents_jug eq "N"){
          ${$count_dms{$keys}}[0] ++;
       }
    }else{
       die "Wrong type of DMS!!!\n"; 
    }
    ${$count_dms{$keys}}[1] ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <qvalue results> <DMS type [DMS|pDMS|sDMS]> <TE position> <10 TE type> <OUTPUT>
    This is to get DMSs distribution throughth TE
DIE
}
