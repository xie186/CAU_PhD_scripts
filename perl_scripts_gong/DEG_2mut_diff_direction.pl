#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($diff, $cmp1, $cmp2) = @ARGV;
my @cmp1 = split(/,/, $cmp1);
my @cmp2 = split(/,/, $cmp2);
my %diff_gene;
open DIFF,$diff or die "$!";
while(<DIFF>){
    chomp;
    #test_id gene_id gene    locus   sample_1        sample_2        status  value_1 value_2 log2(fold_change)       test_stat       p_value q_value significant
    #AT1G05420       AT1G05420       AT1G05420       chr1:1590072-1590753    q1      q2      OK      0       0.818126        inf     -nan    0.00055 0.0172711       yes
    my ($id,$gene_id,$gene,$locus,$sam1,$sam2,$stat,$value_1,$value_2,$fc_log2,$test_stat,$p_value,$q_value,$sig) = split(/\t/);
    if($sig eq "yes" && $sam1 eq $cmp1[0] && $sam2 eq $cmp1[1]){
        $diff_gene{$gene_id} = "$sam1,$sam2\t$value_1\t$value_2\t$fc_log2\t$p_value\t$q_value\t$sig";
    }
}
close DIFF;


open DIFF,$diff or die "$!";
while(<DIFF>){
    chomp;
    my ($id,$gene_id,$gene,$locus,$sam1,$sam2,$stat,$value_1,$value_2,$fc_log2,$test_stat,$p_value,$q_value,$sig) = split(/\t/);
    
    if($sig eq "yes" && $sam1 eq $cmp2[0] && $sam2 eq $cmp2[1]){
        if(exists $diff_gene{$gene_id}){
            my ($tem_sam, $tem_value_1, $tem_value_2, $tem_fc_log2, $tem_p_value, $tem_q_value, $tem_sig) = split(/\t/, $diff_gene{$gene_id});
            #if(($tem_fc_log2 > 0 && $fc_log2 > 0) || ($tem_fc_log2 < 0 && $fc_log2 < 0)){
            #my $tem = $tem_fc_log2 * $fc_log2;
            if($tem_fc_log2 * $fc_log2 > 0){
                print "$gene_id\t$diff_gene{$gene_id}\t$sam1,$sam2\t$value_1\t$value_2\t$fc_log2\t$p_value\t$q_value\t$sig\n";
            }
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <diff> <cmp1> <cmp2>
DIE
}
