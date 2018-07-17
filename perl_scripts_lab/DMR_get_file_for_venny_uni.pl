#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($cmp, $context, $cutoff ,$out) = @ARGV;
my %cmp_all;
my @cmp = split(/,/, $cmp);
foreach my $tem_cmp(@cmp){
    open CMP,$tem_cmp or die "$! $tem_cmp";
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
}
$context =~ s/,/\t/g;
open OUT, "+>$out" or die "$!";
print OUT "id\t$context\n";
foreach(keys %cmp_all){
    if(@{$cmp_all{$_}} == @cmp){
        my $stat = join("\t", @{$cmp_all{$_}});
        next if ($stat !~ /I/ && $stat !~ /D/);
        $_ =~ s/\t/_/g;
        print OUT "$_\t$stat\n";
    }
}
close OUT;

sub usage{
    my $die =<<DIE;

    perl *.pl <cmp [156,204]> <context[156,205]> <cut [0.4 0.2 0.1]> <OUT>

DIE
}
