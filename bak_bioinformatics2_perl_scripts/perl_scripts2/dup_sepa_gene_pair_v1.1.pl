#!/usr/bin/perl -w
use strict;
my ($sub_geno,$ks,$out)=@ARGV;
die usage() unless @ARGV==3;
open SUB,$sub_geno or die "$!";
my %hash_subgeno;
while(<SUB>){
    chomp;
    next if !/^\d/;
    my ($chr,$stt,$end,$sub_nu)=split;
    print "$chr,$stt,$end,$sub_nu\n";
    $hash_subgeno{"$chr\t$stt\t$end"}=$sub_nu;
}

my %hash_match_Sb;
open DUPKS,$ks or die "$!";
my @ks_file=<DUPKS>;
my $ks_file=join('',@ks_file);
   @ks_file=split(/##/,$ks_file);
foreach(@ks_file){
    my @ks_line=split(/\n/,$_);
    my %hash_tem;
    my %hash_two;
    foreach my $line(@ks_line){
        next if $line=~/#/;
        my ($ks,$ka,$sorghum,$zm)=(split(/\s+/,$line))[0,1,3,7];
        my ($chr1,$stt1,$end1,$ge_sb)=(split(/\|\|/,$sorghum))[0,1,2,3];
        my ($chr2,$stt2,$end2,$ge_zm)=(split(/\|\|/,$zm))[0,1,2,3];
        next if ( ($chr1 == 1 && $chr2==3 ) || ($chr1 == 8 && $chr2==2 ));  ### delete the undefinde block 
        my $ge_zm_pos="$chr2\t$stt2\t$end2\t$ge_zm";
        push @{$hash_tem{$ge_sb}},$ge_zm_pos;
        ($ka,$ks)=(0,0) if $ka eq "undef";
        @{$hash_two{"$ge_sb\t$ge_zm_pos"}}=($ka,$ks);
    }

    foreach my $ge_sb(keys %hash_tem){
        next if  @{$hash_tem{$ge_sb}}>1; 
        push @{$hash_match_Sb{$ge_sb}},@{$hash_tem{$ge_sb}};
    }
#    %hash_tem=(); # empty the %hash_tem
}

open OUT,"+>$out" or die "$out";
foreach my $ge_sb(keys %hash_match_Sb){
    print OUT "$ge_sb";
    foreach my $ge_zm(@{$hash_match_Sb{$ge_sb}}){
        my ($chr,$stt,$end,$gene)=split(/\t/,$ge_zm);
        my $sub_geno_tem=&deter_sub($chr,$stt,$end,$gene);
        print OUT "\t$gene\t$sub_geno_tem";
    }
    print OUT "\n";
}
close OUT;

sub deter_sub{
    my ($chr,$stt,$end,$gene)=@_;
    my $return=0;
    foreach(keys %hash_subgeno){
        my ($chr_geno,$stt_geno,$end_geno)=split(/\t/,$_);
        if($chr == $chr_geno && $stt>=$stt_geno && $end<=$end_geno){
            print "$chr == $chr_geno && $stt>=$stt_geno && $end<=$end_geno\n" if $gene eq "AC234171.1_FG001";
            $return=$hash_subgeno{$_};
        }
    }
    return $return;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Subgenome> <SynMap Ks> <OUTPUT>
DIE
}
