#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($alle,$inbred,$mm)=@ARGV;

open ALLE,$alle or die "$!";
my %hash;
while(<ALLE>){
    chomp;
    my ($chr,$pos,$bm_b,$bm_bnu,$bm_m,$bm_mnu,$mb_b,$mb_bnu,$mb_m,$mb_mnu)=(split)[0,1,2,3,4,5,6,7,8,9];
    $hash{"$chr\t$pos"}=[$chr,$pos,$bm_b,$bm_bnu,$bm_m,$bm_mnu,$mb_b,$mb_bnu,$mb_m,$mb_mnu];
    #print "xx\n";
}

open PILEUP,$inbred or die "$!";
my %hash_bb;my %hash_mm;
while(<PILEUP>){
    chomp;
    my ($chr_p,$pos_p,$base,$nu,$match)=(split)[0,1,2,3,4];
    next if $nu<5;
    
    if(exists $hash{"$chr_p\t$pos_p"}){

        my ($chr,$pos,$bm_b,$bm_bnu,$bm_m,$bm_mnu,$mb_b,$mb_bnu,$mb_m,$mb_mnu)=@{$hash{"$chr_p\t$pos_p"}};
        
        my $match_nu=$match=~s/[\.\,]//g;
        my $snp_manu=$match=~s/$bm_m/x/ig;
#        if($match=~/$bm_b/i && $ma=$match!~/[\.\,]/){
        if($match_nu/$nu>=0.8){
          #  print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t$mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\n";
            $hash_bb{"$chr_p\t$pos_p"}=$bm_b;
#            print "$chr\t$pos\t$bm_m\t$bm_mnu\t$bm_b\t$bm_bnu\t$mb_m\t$mb_mnu\t$mb_b\t$mb_bnu\n";
     #       print "sss\n";
        }elsif($snp_manu/$nu>=0.8){
             $hash_bb{"$chr_p\t$pos_p"}=$bm_m;
#            print "$chr\t$pos\t$bm_m\t$bm_mnu\t$bm_b\t$bm_bnu\t$mb_m\t$mb_mnu\t$mb_b\t$mb_bnu\n$_\n";
        }
#        delete $hash{"$chr_p\t$pos_p"};    
    }
}

open MM,$mm or die "$!";
while(<MM>){
    chomp;
    my ($chr_p,$pos_p,$base,$nu,$match)=(split)[0,1,2,3,4];
    next if $nu<5;
    if(exists $hash{"$chr_p\t$pos_p"}){
        my ($chr,$pos,$bm_b,$bm_bnu,$bm_m,$bm_mnu,$mb_b,$mb_bnu,$mb_m,$mb_mnu)=@{$hash{"$chr_p\t$pos_p"}};
        my $match_nu=$match=~s/[\.\,]//g;
        my $snp_manu=$match=~s/$bm_m/x/ig;
        if($match_nu/$nu>=0.8){
            $hash_mm{"$chr_p\t$pos_p"}=$bm_b;
        }elsif($snp_manu/$nu>=0.8){
             $hash_mm{"$chr_p\t$pos_p"}=$bm_m;
        }
    }
}

foreach(keys %hash){
    my ($chr,$pos,$bm_b,$bm_bnu,$bm_m,$bm_mnu,$mb_b,$mb_bnu,$mb_m,$mb_mnu)=@{$hash{"$_"}};
#    print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t $mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\n";
     if(exists $hash_bb{"$_"} && exists $hash_mm{"$_"}){
          if($hash_bb{"$_"} eq $bm_b && $hash_mm{"$_"} eq $bm_m){
              print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t$mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\n";   
          }elsif($hash_bb{"$_"} eq $bm_m && $hash_mm{"$_"} eq $bm_b){
              print "$chr\t$pos\t$bm_m\t$bm_mnu\t$bm_b\t$bm_bnu\t$mb_m\t$mb_mnu\t$mb_b\t$mb_bnu\n";
          }elsif($hash_bb{"$_"} eq $hash_mm{"$_"}){
              print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t$mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\tNA\n";
          }else{
              print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t$mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\tXXX\n";
          }
     }else{
         print "$chr\t$pos\t$bm_b\t$bm_bnu\t$bm_m\t$bm_mnu\t$mb_b\t$mb_bnu\t$mb_m\t$mb_mnu\tNotSure\n";
     }
}

sub usage{
    my $die=<<DIE;

    perl *.pl <ALLELE_snp> <B X B Inbred pileup> < Mo X Mo>

DIE
}
