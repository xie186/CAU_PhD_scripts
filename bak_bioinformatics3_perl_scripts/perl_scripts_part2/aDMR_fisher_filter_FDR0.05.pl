#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($fisher,$cut,$stat_out,$out) = @ARGV;
open FISH,$fisher or die "$!";
open OUT1,"+>$out" or die "$!";
open OUT2,"+>$stat_out" or die "$!";

my ($stat_sig_nu,$stat_2fc,$stat_pass,$stat_tot_nu) = (0,0,0,0);
while(<FISH>){
    chomp;
    ++ $stat_tot_nu;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split;
    my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);
    my @mth_lev_srt = sort{$a<=>$b} ($mth_lev1,$mth_lev2);
    if($p_value <= $cut){
        ++ $stat_sig_nu;
        if($mth_lev_srt[1] >=2*$mth_lev_srt[0]){
            ++$stat_2fc;
            if($mth_lev_srt[1] >= 0.5){
                ++ $stat_pass;
                print OUT1 "$chr\t$stt\t$end\t$c_cover1\t$c_nu1\t$t_nu1\t$mth_lev1\t$c_cover2\t$c_nu2\t$t_nu2\t$mth_lev2\t$p_value\n";
            }
        }
    }
}

my $perc_p_filter = $stat_sig_nu/$stat_tot_nu;
my $perc_2fc_filter = $stat_2fc/$stat_tot_nu;
my $perc_pass_filter = $stat_pass/$stat_tot_nu;

print OUT2 <<OUT;
Total windows: $stat_tot_nu;
Filtered by p_value ($cut): $stat_sig_nu ($perc_p_filter);
Filtered by fold-change (2): $stat_2fc ($perc_2fc_filter);
Filtered by higher meth_lev greater than 0.5: $stat_pass ($perc_pass_filter);
OUT

sub usage{
    my $die=<<DIE;
    perl *.pl <Fisher's exact test> <p_value cut> <statistic output> <filter output>
DIE
}
