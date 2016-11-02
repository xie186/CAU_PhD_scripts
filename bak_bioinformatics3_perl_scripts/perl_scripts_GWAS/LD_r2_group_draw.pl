#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
use Statistics::R;
my $REGION = "region";
my $P_LOG = "p_log";
my ($r2_pwd,$p_log_pwd,$gene,,$r_code,$group,$win) = @ARGV;
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

my $R = Statistics::R ->new();
foreach(keys %group_region){
    my $r2 = "LD_grp.$pheno.$r2_cut.$_.r2";
    my $p_log = "LD_grp.$pheno.$r2_cut.$_.p_log";
    my $pdf = "LD_grp.$pheno.$r2_cut.$_.tif";
    next if (!-e "$p_log_pwd/$p_log" || !-e "$r2_pwd/$r2" || !-e "$gene");
    my $R_CMD = <<CMD;
    tiff("$pdf", compression = c("lzw"))
    source("$r_code")
    draw_LD_grp_exam("$p_log_pwd/$p_log","$r2_pwd/$r2","$gene")
    dev.off()
CMD
    my $run = $R ->run($R_CMD);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <r2_pwd> <p_log_pwd> <gene> <r_code> <P_log> <group> <window size> 
DIE
}
