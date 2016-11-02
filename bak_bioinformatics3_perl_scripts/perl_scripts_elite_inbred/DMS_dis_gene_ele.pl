#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($dms, $ge_pos, $dms_type, $out) = @ARGV;

open DMS,$dms or die "$!";
my %dms_pos;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_bw_parents_jug) = split;
    next if ($lev1 < 0.6 && $lev2 < 0.6);  #assure the sites was methylated
    @{$dms_pos{"$chr\t$stt"}} = ($qval, $dms_bw_parents_jug);
}
close DMS;

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$ge_pos or die;
my $flag =0;
my %dms_stat;
while(my $line=<POS>){
        print "$flag have been done\n" if $flag%5000==0;$flag++;
        chomp $line;
        next if $line =~ /^#/;
        my ($chr,$ele,$stt,$end,$strand,$name)=(split(/\t/,$line))[0,2,3,4,6,8];
        next if $ele eq "gene";
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt;$i <= $end;++$i){
            if(exists $dms_pos{"$chr\t$i"}){
                &cal($stt,$end,$strand,$i, @{$dms_pos{"$chr\t$i"}},$ele);
            }
        }
}

foreach(sort keys %dms_stat){
    my $dms_statprint = 0;
    for(my $i =0;$i<=49;++$i){
        if(exists $dms_stat{$_}->{$i}){
            $dms_statprint = 1000 * ${$dms_stat{$_}->{$i}}[1]  / ${$dms_stat{$_}->{$i}}[0];
        }
        print OUT "$_\t$i\t$dms_statprint\n";
    }
}
close OUT;

sub cal{
    my ($stt,$end,$strand,$pos1, $qval, $dms_bw_parents_jug, $ele)=@_;
    my $unit=($end-$stt+1)/50;
    my $keys=0;
    if($strand eq '+'){
        $keys=int (($pos1-$stt+1)/$unit);
    }else{
        $keys=int (($end-$pos1+1)/$unit);
    }
    $keys-=1 if $keys == 50;
    ${$dms_stat{$ele}->{$keys}}[0] ++;    ## all sites
    if($dms_type eq "DMS"){                 ## DMSs
        ${$dms_stat{$ele}->{$keys}}[1] ++ if $qval < 0.01;
    }elsif($dms_type eq "pDMS"){
        ${$dms_stat{$ele}->{$keys}}[1] ++ if ($qval < 0.01 && $dms_bw_parents_jug eq "Y");
    }elsif($dms_type eq "sDMS"){
        ${$dms_stat{$ele}->{$keys}}[1] ++ if ($qval < 0.01 && $dms_bw_parents_jug eq "N");
    }else{
        die "Wrong Types!!!\n";
    }
}

sub usage{
    my $die=<<DIE;

    perl *.pl <DMS qvalue> <Gene position GFF> <DMS type> <OUTPUT>
    This is to DMSs distribution across genes.

DIE
}
