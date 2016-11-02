#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==5;
my ($fisher,$fisher2,$cut,$regions_analyze,$stat_out) = @ARGV;
open FISH,$fisher or die "$!";
open OUT1,"+>$regions_analyze" or die "$!";
open OUT2,"+>$stat_out" or die "$!";

my %hash_all;
my ($overlap_win, $mat, $pat, $gDMR_b73, $gDMR_mo17 ) = (0, 0, 0, 0, 0);
while(<FISH>){   ## BM
    chomp;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split;
       $hash_all{"$chr\t$stt\t$end"} = $_;
}

open FISHER2,$fisher2 or die "$!";
while(<FISHER2>){
     chomp;
     my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split; ## MB 
     next if !exists $hash_all{"$chr\t$stt\t$end"};
     print OUT1 "$chr\t$stt\t$end\n";
     ++ $overlap_win;
     my ($lap_chr,$lap_stt,$lap_end,$lap_c_cover1,$lap_c_nu1,$lap_t_nu1,$lap_c_cover2,$lap_c_nu2,$lap_t_nu2,$lap_p_value) = split(/\t/,$hash_all{"$chr\t$stt\t$end"});
     my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);  ## MB_B
     my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);  ## MB_M
     my $lap_mth_lev1 = $lap_c_nu1 / ($lap_c_nu1 + $lap_t_nu1);   ## BM_B
     my $lap_mth_lev2 = $lap_c_nu2 / ($lap_c_nu2 + $lap_t_nu2);   ## BM_M
     if($p_value <= $cut && $lap_p_value <=$cut){
          #  MB_B > MB_M          &&       BM_B < BM_M
         if($mth_lev1 > $mth_lev2 && $lap_mth_lev1 < $lap_mth_lev2 ){
             ++ $pat;
         }elsif($mth_lev1 < $mth_lev2 && $lap_mth_lev1 > $lap_mth_lev2){
             ++ $mat;
         }elsif($mth_lev1 > $mth_lev2 && $lap_mth_lev1 > $lap_mth_lev2 ){
             ++ $gDMR_b73;
         }elsif($mth_lev1 < $mth_lev2 && $lap_mth_lev1 < $lap_mth_lev2 ){
             ++ $gDMR_mo17;
         }
     }
}

my $perc_mat = $mat/$overlap_win;
my $perc_pat = $pat/$overlap_win;
my $perc_b73 = $gDMR_b73/$overlap_win;
my $perc_mo17 = $gDMR_mo17/$overlap_win;

print OUT2 <<OUT;
Total windows (4 alleles): $overlap_win;
Filtered by p_value (mat > pat) ($cut): $mat ($perc_mat);
Filtered by p_value (pat > mat)($cut): $pat ($perc_pat);
Filtered by p_value (b73 > m17) ($cut): $gDMR_b73 ($perc_b73);
Filtered by p_value (m17 > b73) ($cut): $gDMR_mo17 ($perc_mo17);
OUT

sub usage{
    my $die=<<DIE;
    perl *.pl <Fisher's exact test BM> <Fisher's exact test [BM]> <p_value cut> <Windows we can analyzed><statistic output>
    we use this scripts to get the overlapped windows(windows that we can analyze) in the 4 alleles of BM and MB.
DIE
}
