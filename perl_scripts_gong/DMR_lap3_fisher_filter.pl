#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==8;
my ($fisher1,$fisher2,$fisher3,$cut,$lev_cut,$out1,$out2,$out3) = @ARGV;
open FISH1,$fisher1 or die "$!";
open OUT1,"+>$out1" or die "$!";
open OUT2,"+>$out2" or die "$!";
open OUT3,"+>$out3" or die "$!";
my %hash_lap;
my %hash_orientation;
while(<FISH1>){
    chomp;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split;
       ${$hash_lap{"$chr\t$stt\t$end"}}[0] ++;
    my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);
    if($p_value <= $cut){
        if(abs($mth_lev1 - $mth_lev2) >= $lev_cut){
            if($mth_lev1 - $mth_lev2 > 0){
                 ${$hash_lap{"$chr\t$stt\t$end"}}[1] = "positive";
            }else{
                  ${$hash_lap{"$chr\t$stt\t$end"}}[1] = "negative";
            }
        }else{
            ${$hash_lap{"$chr\t$stt\t$end"}}[1] = "diff_no_sig";
        }
    }else{
        ${$hash_lap{"$chr\t$stt\t$end"}}[1] = "non_diff";
    }
}

open FISH2,$fisher2 or die "$!";
while(<FISH2>){
    chomp;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split;
       ${$hash_lap{"$chr\t$stt\t$end"}}[0] ++;
    my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);
    if($p_value <= $cut){
        if(abs($mth_lev1 - $mth_lev2) >= $lev_cut){
            if($mth_lev1 - $mth_lev2 > 0){
                 ${$hash_lap{"$chr\t$stt\t$end"}}[2] = "positive";
            }else{
                  ${$hash_lap{"$chr\t$stt\t$end"}}[2] = "negative";
            }
        }else{
            ${$hash_lap{"$chr\t$stt\t$end"}}[2] = "diff_no_sig";
        }
    }else{
        ${$hash_lap{"$chr\t$stt\t$end"}}[2] = "non_diff";
    }    
}

open FISH3,$fisher3 or die "$!";
while(<FISH3>){
    chomp;
    my ($chr,$stt,$end,$c_cover1,$c_nu1,$t_nu1,$c_cover2,$c_nu2,$t_nu2,$p_value) = split;
       ${$hash_lap{"$chr\t$stt\t$end"}}[0] ++;
    my $mth_lev1 = $c_nu1/($c_nu1 + $t_nu1);
    my $mth_lev2 = $c_nu2/($c_nu2 + $t_nu2);
    if($p_value <= $cut){
        if(abs($mth_lev1 - $mth_lev2) >= $lev_cut){
            if($mth_lev1 - $mth_lev2 > 0){
                 ${$hash_lap{"$chr\t$stt\t$end"}}[3] = "positive";
            }else{
                  ${$hash_lap{"$chr\t$stt\t$end"}}[3] = "negative";
            }
        }else{
            ${$hash_lap{"$chr\t$stt\t$end"}}[3] = "diff_no_sig";
        }
    }else{
        ${$hash_lap{"$chr\t$stt\t$end"}}[3] = "non_diff";
    }
}


foreach(keys %hash_lap){
    next if ${$hash_lap{$_}}[0] !=3;
    my $key=$_;
    $key =~ s/\t/_/g;
    if(${$hash_lap{$_}}[1] =~ /tive/){
        print OUT1 "$key\_${$hash_lap{$_}}[1]\n";
    }
    if(${$hash_lap{$_}}[2] =~ /tive/){
        print OUT2 "$key\_${$hash_lap{$_}}[2]\n";
    }
    if(${$hash_lap{$_}}[3] =~ /tive/){
        print OUT3 "$key\_${$hash_lap{$_}}[3]\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Fisher's exact test1> <Fisher's exact test2> <>Fisher's exact test3 <p_value cut> <meth_lev_cut> <out1 156> <out2 204> <OUT nrpd1a>
DIE
}
