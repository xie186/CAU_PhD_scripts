#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($dms,$ge_pos, $judge, $out)=@ARGV;
my $BIN = 60;

my %dms_pos;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    next if /#/;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_bw_parents_jug) = split;
    @{$dms_pos{"$chr\t$stt"}} = ($qval, $dms_bw_parents_jug);
}

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my %count_dms;
while(my $line=<POS>){
        chomp $line;
        my $len_index = "NA";
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        if($end - $stt +1 <= 600){
            $len_index = "<400";
        }elsif($end - $stt +1 >=601 && $end - $stt +1 <=1200){
            $len_index = "601-1200";
        }elsif($end - $stt +1 >=1201 && $end - $stt +1 <=1800){
            $len_index = "1201-1800";
        }elsif($end - $stt +1 >=1801){
            $len_index = ">1801";
        }
        #if($end - $stt +1 <= 401){
        #    $len_index = "<400";
        #}elsif($end - $stt +1 >=401 && $end - $stt +1 <=600){
        #    $len_index = "401-600";
        #}elsif($end - $stt +1 >=601 && $end - $stt +1 <=800){
        #    $len_index = "601-800";
        #}elsif($end - $stt +1 >=801 && $end - $stt +1 <=1000){
        #    $len_index = "801-1000";
        #}elsif($end - $stt +1 >=1001 && $end - $stt +1 <=1200){
        #    $len_index = "1001-1200";
        #}elsif($end - $stt +1 >=1001 && $end - $stt +1 <=1400){
        #    $len_index = "1201-1400";
        #}elsif($end - $stt +1 >=1001 && $end - $stt +1 <=1600){
        #    $len_index = "1401-1600";
        #}else{
        #    $len_index = ">1601";
        #}
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $dms_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$dms_pos{"$chr\t$i"}}, $len_index);
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
    my ($stt,$end,$strand,$pos1,$qval, $dms_bw_parents_jug, $len_index) = @_;
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
    $keys.="\t$len_index";
    if($judge eq "DMS_stab"){
        if($qval < 0.01 && $dms_bw_parents_jug eq "S"){
            ${$count_dms{$keys}}[0] ++;
        }
    }elsif($judge eq "DMS_var"){
        if($qval < 0.01 && $dms_bw_parents_jug eq "V"){
            ${$count_dms{$keys}}[0] ++;
        }
    }elsif($judge eq "pDMS"){
        if($qval < 0.01 && $dms_bw_parents_jug eq "Y"){
            ${$count_dms{$keys}}[0] ++;
        }
    }elsif($judge eq "sDMS"){
        if($qval < 0.01 && $dms_bw_parents_jug eq "N"){
            ${$count_dms{$keys}}[0] ++;
        }
    }elsif($judge eq "DMS"){
        if($qval < 0.01){
            ${$count_dms{$keys}}[0] ++;
        }
    }else{
        die "Wrong type!\n";
    }
    ${$count_dms{$keys}}[1] ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <qvalue results> <Gene position> <judge [DMS_stable, DMS_variable, pDMS, sDMS, DMS]> <OUTPUT>
    This is to get DMSs distribution throughth gene
DIE
}
