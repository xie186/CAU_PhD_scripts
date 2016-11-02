#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my $REGION = "region";
my $P_LOG = "p_log";
my ($p_log,$group,$win) = @ARGV;
open GROUP,$group or die "$!";
my ($pheno,$r2_cut) = $group =~ /GAPIT.(.*).photype.peak_group.(.*).res/;
my @group = <GROUP>;
my $tem_group = join('',@group);
   @group = split(/###/,$tem_group);
shift @group;
my %group_region;
foreach(@group){
    my ($group_head,@peak_snp) = split(/\n/);
    if(/_ungroup_/){
        for(my $i = 0;$i<= $#peak_snp;++$i){
            my ($chr,$pos) = $peak_snp[$i] =~ /(chr\d+)\_(\d+)/;
            my ($stt,$end) = ($pos - $win/2,$pos + $win/2);
            $group_region{"ungrp\_$i"} ->{$REGION} = "$chr\t$stt\t$end";
        }
    }else{
        my ($grp_id,$chr,$stt,$end) = split(/\t/,$group_head);
           ($stt,$end) = ($stt - $win/2, $end + $win/2);
        $group_region{$grp_id} -> {$REGION} = "$chr\t$stt\t$end";
    }
}

#open XX, "+>test.DTS.hapmap";
open LOG,$p_log or die "$!";
while(<LOG>){
     chomp;
     &judge_snp($_);
}

foreach(keys %group_region){
    open OUT,"+>LD_grp.$pheno.$r2_cut.$_.p_log" or die "$!";
    foreach my $p_log (@{$group_region{$_}->{$P_LOG}}){
        print OUT "$p_log\n";
    }
}

sub judge_snp{   # get  the hapmap in the peak regions
    my ($plog_line) = @_;
    my ($chr,$pos) = split(/\t/,$plog_line);
        $chr = "chr".$chr;
    foreach(keys %group_region){
        my ($tem_chr,$stt,$end) = split(/\t/,$group_region{$_}->{$REGION});
        if($tem_chr eq $chr && $pos >= $stt && $pos <= $end){
            push @{$group_region{$_}->{$P_LOG}} , $plog_line;
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <P_log> <group> <window size> 
DIE
}
