#!/usr/bin/perl -w
use strict;
die usage() unless  @ARGV == 4;
my ($cmp1,$cmp2,$cut,$stat) = @ARGV;

my ($stat_lap_nu,$stat_sig_p_nu1,$stat_sig_cut_nu1,$stat_sig_p_nu2,$stat_sig_cut_nu2, $stat_lap_sig_p_nu,$stat_lap_sig_cut);
my %hash_lap;
open CMP1,$cmp1 or die "$!";
while(<CMP1>){
    chomp;
    my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split;
    my $lev1 = $c_nu1 / ($c_nu1+$t_nu1);
    my $lev2 = $c_nu2 / ($c_nu2+$t_nu2);
    ${$hash_lap{"$chr\t$pos"}->{"1"}}[0] = "$lev1\t$lev2";
    if ($p_value <=0.01){
        ${$hash_lap{"$chr\t$pos"}->{"1"}}[1] = "y";
    }else{
        ${$hash_lap{"$chr\t$pos"}->{"1"}}[1] = "n";
    }
    if(abs($lev1-$lev2) >= $cut){
        ${$hash_lap{"$chr\t$pos"}->{"1"}}[2] = "y";
    }else{
        ${$hash_lap{"$chr\t$pos"}->{"1"}}[2] = "n";
    }
}

open CMP2,$cmp2 or die "$!";
while(<CMP2>){
    chomp;
    my ($chr,$pos,$c_nu1,$t_nu1,$c_nu2,$t_nu2,$p_value) = split;
    my $lev1 = $c_nu1 / ($c_nu1+$t_nu1);
    my $lev2 = $c_nu2 / ($c_nu2+$t_nu2);
    ${$hash_lap{"$chr\t$pos"}->{"2"}}[0] = "$lev1\t$lev2";
    if ($p_value <=0.01){
        ${$hash_lap{"$chr\t$pos"}->{"2"}}[1] = "y";
    }else{
        ${$hash_lap{"$chr\t$pos"}->{"2"}}[1] = "n";
    }
    if(abs($lev1-$lev2) >= $cut){
        ${$hash_lap{"$chr\t$pos"}->{"2"}}[2] = "y";
    }else{
        ${$hash_lap{"$chr\t$pos"}->{"2"}}[2] = "n";
    }
}

foreach(keys %hash_lap){
    if(exists $hash_lap{$_}->{"1"} && exists $hash_lap{$_}->{"2"}){
        my ($lev_cmp1, $sig_p_cmp1, $sig_cut_cmp1) = @{$hash_lap{$_}->{"1"}};
        my ($lev_cmp2, $sig_p_cmp2, $sig_cut_cmp2) = @{$hash_lap{$_}->{"2"}};
           $stat_lap_nu ++;
           $stat_sig_p_nu1 ++ if $sig_p_cmp1  eq "y";
           $stat_sig_cut_nu1 ++ if ( $sig_p_cmp1  eq "y" && $sig_cut_cmp1 eq  "y" ) ;
           $stat_sig_p_nu2 ++ if $sig_p_cmp2 eq "y";
           $stat_sig_cut_nu2 ++ if ($sig_p_cmp2 eq "y" && $sig_cut_cmp2 eq "y");
           $stat_lap_sig_p_nu ++ if ($sig_p_cmp1 eq "y" && $sig_p_cmp2 eq "y");
           $stat_lap_sig_cut ++ if ($sig_p_cmp1 eq "y" && $sig_p_cmp2 eq "y" && $sig_cut_cmp1 eq "y" && $sig_cut_cmp2 eq "y");
        print "$_\tlap\t$lev_cmp1\t$sig_p_cmp1\t$sig_cut_cmp1\t$lev_cmp2\t$sig_p_cmp2\t$sig_cut_cmp2\n";
    }elsif(exists $hash_lap{$_}->{"1"} && !exists $hash_lap{$_}->{"2"}){
        my ($lev_cmp1, $sig_p_cmp1, $sig_cut_cmp1) = @{$hash_lap{$_}->{"1"}};
        print "$_\tnolap\t$lev_cmp1\t$sig_p_cmp1\t$sig_cut_cmp1\t-\t-\t-\n";
    }elsif(!exists $hash_lap{$_}->{"1"} && exists $hash_lap{$_}->{"2"}){
        my ($lev_cmp2, $sig_p_cmp2, $sig_cut_cmp2) = @{$hash_lap{$_}->{"2"}};
        print "$_\tnolap\t-\t-\t-\t$lev_cmp2\t$sig_p_cmp2\t$sig_cut_cmp2\n";
    }
}

open STAT,"+>$stat" or die "$!";
print STAT <<STAT;
total_overlapped_number	$stat_lap_nu
significant_p1	$stat_sig_p_nu1
significant_cut1	$stat_sig_cut_nu1
significant_p2	$stat_sig_p_nu2
significant_cut2	$stat_sig_cut_nu2
significant_both_p	$stat_lap_sig_p_nu
significant_both_cut	$stat_lap_sig_cut
STAT

sub usage{
    print <<DIE;
    perl *.pl <Comparison1> <Comparison2> <Cutoff> <Statistics>
DIE
   exit 1;
}

