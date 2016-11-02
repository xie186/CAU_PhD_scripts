#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($geno,$dmr_pos,$ana_region,$out)=@ARGV;

open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
@aa=split(/>/,$join);
$join=@aa; #chromosome number
my %hash;
for(my $i = 1; $i <= $join; ++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $hash{$chr}=$tem_seq;
}
close GENO;

open ANA, $ana_region or die "$!";
my @ana_region;
while(<ANA>){
    chomp;
    push @ana_region, $_;
}
close ANA;

my $ana_reg_num = @ana_region;
my %bas_com;
open DMR,$dmr_pos or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end,$all_sites,$context) = split;
    next if $all_sites < 5;
    my $mid = int( ($stt+$end)/2 );
    my $rand_num = int (rand ($ana_reg_num));
#    print "xx\t$rand_num\t$ana_reg_num\n";
    my ($rand_chr,$rand_stt,$rand_end,$rand_all_sites) = split(/\t/,$ana_region[$rand_num]);
    my $mid_rand = int(($rand_stt + $rand_end)/2);
    for(my $i = -20;$i < 20; ++$i){
        &cal($chr, $mid, $i, $context);
        &cal($chr, $mid_rand, $i, "Random");
    }
}
close DMR;

open OUT, "|sort -k1,1 -k2,2n > $out" or die "$!";
foreach(sort keys %bas_com){
    my $all_stat = join("\t",@{$bas_com{$_}});
    print OUT "$_\t$all_stat\n";
}
close OUT;

sub cal{
    my ($chr, $mid, $i, $stat) = @_;
    if($mid + $i*100 +100 < length $hash{$chr} && $mid + $i*100 >= 0){
        my $tem_seq = substr($hash{$chr}, $mid + $i*100, 100);
        my $c_num =  $tem_seq =~ s/C/C/g; 
        my $g_num =  $tem_seq =~ s/G/G/g;
        my $all_num =  $tem_seq =~ tr/ATGC/ATGC/;
        my $keys = "$stat\t$i";
        ${$bas_com{$keys}}[0] += $c_num;
        ${$bas_com{$keys}}[1] += $g_num;
        ${$bas_com{$keys}}[2] += $all_num;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <geno_seq> <DMR> <analyzable regions> <OUTPUT>
    This is to get G+C base composition distribution throughth gene
DIE
}
