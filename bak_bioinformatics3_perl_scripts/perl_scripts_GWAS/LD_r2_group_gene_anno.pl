#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my $REGION = "region";
my $PEAK = "peak";
my $GENE = "gene";
my ($gene,$gene_anno,$group,$win) = @ARGV;
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
            push @{$group_region{"ungrp\_$i"} ->{$PEAK}} , $pos;
        }
    }else{
        my ($grp_id,$chr,$stt,$end) = split(/\t/,$group_head);
           ($stt,$end) = ($stt - $win/2, $end + $win/2);
        $group_region{$grp_id} -> {$REGION} = "$chr\t$stt\t$end";
        foreach my $tem_peak(@peak_snp){
            my ($chr,$pos) = $tem_peak =~ /(chr\d+)\_(\d+)/; 
            push @{$group_region{$grp_id} ->{$PEAK}},$pos;
        }
    }
}

open GE,$gene or die "$!";
while(<GE>){
     chomp;
     &judge_gene($_);
}

open ANNO,$gene_anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,@tem_anno) = split(/\t/);
    my $tem_anno= join("\t",@tem_anno);
    $gene_anno{$gene} = $tem_anno;
}

foreach(sort keys %group_region){
    my ($tem_chr,$stt,$end) = split(/\t/,$group_region{$_}->{$REGION});
    print "###$_\t$tem_chr\t$stt\t$end\n";
    foreach my $tem_gene(@{$group_region{$_}->{$GENE}}){
        my ($chr,$ge_stt,$ge_end,$ge_name,$strand,$dis) = split(/\t/,$tem_gene);
        $gene_anno{$ge_name} = "NA" if !$gene_anno{$ge_name}; 
        print "$tem_gene\t$gene_anno{$ge_name}\n";
    }
}

sub judge_gene{   # get  the hapmap in the peak regions
    my ($gene_line) = @_;
    my ($chr,$ge_stt,$ge_end) = split(/\t/,$gene_line);
        $chr = "chr".$chr if !/chr/;
    foreach(keys %group_region){
        my ($tem_chr,$stt,$end) = split(/\t/,$group_region{$_}->{$REGION});
        if($tem_chr eq $chr && $ge_stt >= $stt && $ge_end <= $end){
            my $dis = &distance($_,$ge_stt,$ge_end);
            push @{$group_region{$_}->{$GENE}} , "$gene_line\t$dis";
        }
    }
}

sub distance{
    my ($tem_group,$stt,$end) = @_;  ###  group , gene stt , gene end
    my @dis;
    foreach my $peak_snp_pos(@{$group_region{$tem_group} ->{$PEAK}}){
        my $minus_stt = $peak_snp_pos - $stt;
        my $minus_end = $peak_snp_pos - $end;
        if($minus_stt >0 && $minus_end >0){
            push @dis , $minus_end;
        }elsif($minus_stt < 0 && $minus_end < 0){
            push @dis , abs($minus_stt);
        }else{
            push @dis , 0;
        }
    }
    my ($dis) = sort {$a<=>$b} @dis;
    return $dis;
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <gene position> <Gene annotation> <group> <window size> 
DIE
}
