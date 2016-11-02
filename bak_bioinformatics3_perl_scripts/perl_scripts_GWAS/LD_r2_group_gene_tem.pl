#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my $REGION = "region";
my $GENE = "gene";
my ($gene,$group,$win) = @ARGV;
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
open GE,$gene or die "$!";
while(<GE>){
     chomp;
     &judge_gene($_);
}

sub judge_gene{   # get  the hapmap in the peak regions
    my ($gene_line) = @_;
    my ($chr,$ge_stt,$ge_end) = split(/\t/,$gene_line);
        $chr = "chr".$chr if !/chr/;
    foreach(keys %group_region){
        my ($tem_chr,$stt,$end) = split(/\t/,$group_region{$_}->{$REGION});
        if($tem_chr eq $chr && $ge_stt >= $stt && $ge_end <= $end){
            print "$gene_line\n";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <gene position> <group> <window size> 
DIE
}
