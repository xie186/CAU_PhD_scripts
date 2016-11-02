#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==5;
my ($fisher,$cut,$lev_cut,$stat_out,$out) = @ARGV;
open FISH,$fisher or die "$!";
open OUT1,"+>$out" or die "$!";
open OUT2,"+>$stat_out" or die "$!";

my ($stat_sig_nu,$stat_lev_cut,$stat_tot_nu) = (0,0,0);
while(<FISH>){
    chomp;
    next if /#/;
    ++ $stat_tot_nu;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_val, $p_val_adj) = split;
    my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);
    if($p_val_adj < $cut){
        ++ $stat_sig_nu;
        if(abs($mth_lev1 - $mth_lev2) >= $lev_cut){
            ++$stat_lev_cut;
            print OUT1 "$chr\t$stt\t$end\t$c_cover1\t$c_nu1\t$t_nu1\t$mth_lev1\t$c_cover2\t$c_nu2\t$t_nu2\t$mth_lev2\t$p_val\t$p_val_adj\n";
        }
    }
}

my $perc_p_filter = $stat_sig_nu/$stat_tot_nu;
my $perc_cut_filter = $stat_lev_cut/$stat_tot_nu;

print OUT2 <<OUT;
Total windows: $stat_tot_nu;
Filtered by p_value ($cut): $stat_sig_nu ($perc_p_filter);
Filtered by meth_lev_cutoff: $stat_lev_cut ($perc_cut_filter);
OUT

sub usage{
    my $die=<<DIE;
    perl *.pl <Fisher's exact test> <p_value cut> <meth_lev_cut> <statistic output> <filter output>
DIE
}
