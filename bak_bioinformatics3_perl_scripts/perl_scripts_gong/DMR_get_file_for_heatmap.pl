#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 7;
my ($cmp_156, $cmp_204, $cmp_nrpd1a, $cmp_ros1, $cutoff ,$out_hypo, $out_hyper) = @ARGV;
my %cmp_all;
open CMP,$cmp_156 or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    if($p_val_adj < 0.01 && abs($mth_lev2 - $mth_lev1) >= $cutoff){
        push @{$cmp_all{"$chr\t$stt\t$end"}}, $mth_lev1;
    }
}
close CMP;

open CMP,$cmp_204 or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    push @{$cmp_all{"$chr\t$stt\t$end"}}, $mth_lev1;
}
close CMP;

open CMP,$cmp_nrpd1a or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    push @{$cmp_all{"$chr\t$stt\t$end"}}, $mth_lev1;
}
close CMP;

open CMP,$cmp_ros1 or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    push @{$cmp_all{"$chr\t$stt\t$end"}}, ($mth_lev1, $mth_lev2);
}
close CMP;

open HYPO, "+>$out_hypo" or die "$!";
open HYPER, "+>$out_hyper" or die "$!";
print HYPO "\t156\t204\tnrpd1a\tros1\tc24\n";
print HYPER "\t156\t204\tnrpd1a\tros1\tc24\n";
foreach(keys %cmp_all){
    if(@{$cmp_all{$_}} == 5){
        if(${$cmp_all{$_}}[0] - ${$cmp_all{$_}}[-1] < 0){
            my $stat = join("\t", @{$cmp_all{$_}});
            $_ =~ s/\t/_/g;
            print HYPO "$_\t$stat\n";
        }else{
            my $stat = join("\t", @{$cmp_all{$_}});
            $_ =~ s/\t/_/g;
            print HYPER "$_\t$stat\n";
        }
    }
}
close HYPO;
close HYPER;

sub usage{
    my $die =<<DIE;

    perl *.pl <156> <204> <nrpd1a> <ros1> <cut [0.4 0.2 0.1]> <OUT hypo> <OUT hyper>

DIE
}
