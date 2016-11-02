#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($gene,$module) = @ARGV;
open MOD,$module or die "$!";
my %module_gene;
my %module_stat;
while(<MOD>){
    chomp;
    my ($gene_id,$num) = split(/\t/);
    $module_gene{$gene_id} = $num;
    $module_stat{$num} ++;
}

my %module_stat_deg;
open GE,$gene or die "$!";
my $tot_DEG  = 0;
while(<GE>){
    chomp;
    my ($gene_id) = split;
    if(exists $module_gene{$gene_id}){
        my $mod_num = $module_gene{$gene_id};
        $module_stat_deg{$mod_num} ++;
        ++ $tot_DEG;
    }
}
close GE;

my $tot_gene = keys %module_gene;

foreach(sort {$a<=>$b} keys %module_stat){
    $module_stat_deg{$_} = 0 if !exists $module_stat_deg{$_};
    my ($pvalue) = &chisq($module_stat_deg{$_} , $module_stat{$_}, $tot_DEG - $module_stat_deg{$_}, $tot_gene - $module_stat{$_});
    print "$_\t$module_stat{$_}\t$module_stat_deg{$_}\t$pvalue\n";
}

sub chisq{
    my ($lap_num1, $lap_num2, $lapno_num1, $lapno_num2) = @_;
    open O,"+>test.R" or die "$!";
    print O "rpkm<-c($lap_num1, $lap_num2, $lapno_num1, $lapno_num2)\ndim(rpkm)=c(2,2)\nfisher.test(rpkm, alternative == \"greater\")\$p.value\n";
    close O;
    my $report=`R --vanilla --slave < test.R`;
    my $p_value=(split(/\s+/,$report))[1] ||0;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <gene> <module> 
DIE
}
