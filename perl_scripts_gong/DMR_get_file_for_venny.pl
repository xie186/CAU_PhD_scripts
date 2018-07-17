#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 6;
my ($cmp_156, $cmp_204, $cmp_ros1, $cmp_nrpd1a, $cutoff ,$out) = @ARGV;
my %cmp_all;
open CMP,$cmp_156 or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    if($p_val_adj < 0.01 && abs($mth_lev2 - $mth_lev1) >= $cutoff){
        if($mth_lev1 - $mth_lev2 > 0){  # mutant - c24 
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "I";
        }else{
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "D";
        }
    }else{
        push @{$cmp_all{"$chr\t$stt\t$end"}}, "U";
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
    if($p_val_adj < 0.01 && abs($mth_lev2 - $mth_lev1) >= $cutoff){
        if($mth_lev1 - $mth_lev2 > 0){
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "I";
        }else{
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "D";
        }
    }else{
        push @{$cmp_all{"$chr\t$stt\t$end"}}, "U";
    }
}
close CMP;

open CMP,$cmp_ros1 or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    if($p_val_adj < 0.01 && abs($mth_lev2 - $mth_lev1) >= $cutoff){
        if($mth_lev1 - $mth_lev2 > 0){
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "I";
        }else{
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "D";
        }
    }else{
        push @{$cmp_all{"$chr\t$stt\t$end"}}, "U";
    }
}
close CMP;

open CMP,$cmp_nrpd1a or die "$!";
while(<CMP>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover1, $c_nu1, $t_nu1, $c_cover2, $c_nu2, $t_nu2, $p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1 / ($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2 / ($c_nu2 + $t_nu2);
    if($p_val_adj < 0.01 && abs($mth_lev2 - $mth_lev1) >= $cutoff){
        if($mth_lev1 - $mth_lev2 > 0){
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "I";
        }else{
            push @{$cmp_all{"$chr\t$stt\t$end"}}, "D";
        }
    }else{
        push @{$cmp_all{"$chr\t$stt\t$end"}}, "U";
    }
}
close CMP;

open OUT, "+>$out" or die "$!";
print OUT "id\t156\t204\tnrpd1a\tros1\n";
foreach(keys %cmp_all){
    if(@{$cmp_all{$_}} == 4){
        my $stat = join("\t", @{$cmp_all{$_}});
        next if ($stat !~ /I/ && $stat !~ /D/);
        $_ =~ s/\t/_/g;
        print OUT "$_\t$stat\n";
    }
}
close OUT;

sub usage{
    my $die =<<DIE;

    perl *.pl <156> <204> <nrpd1a> <ros1> <cut [0.4 0.2 0.1]> <OUT>

DIE
}
