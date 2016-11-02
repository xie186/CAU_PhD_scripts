#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($geno,$dmr_pos,$out)=@ARGV;
my $BIN = 60;

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
my %bas_com;
open DMR,$dmr_pos or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end,$all_sites,$stab) = split;
    my $stat = "Stable";
       $stat = "Unstatble" if $stab/$all_sites < 0.5;
    my $mid = int( ($stt+$end)/2 );
    my $mid_rand = int (rand (length($hash{$chr})));
    for(my $i = -20;$i < 20; ++$i){
        &cal($chr, $mid, $i, $stat);
        &cal($chr, $mid_rand, $i, "Random");
    }
}

open OUT, "|sort -k1,1 -k2,2n > $out" or die "$!";
foreach(sort keys %bas_com){
    my $all_stat = join("\t",@{$bas_com{$_}});
    print OUT "$_\t$all_stat\n";
}
close OUT;

sub cal{
    my ($chr, $mid, $i, $stat) = @_;
    my $tem_seq = substr($hash{$chr}, $mid + $i*100, 100);
    my $c_num =  $tem_seq =~ s/C/C/g; 
    my $g_num =  $tem_seq =~ s/G/G/g;
    my $all_num =  $tem_seq =~ tr/ATGC/ATGC/;
    my $keys = "$stat\t$i";
    ${$bas_com{$keys}}[0] += $c_num;
    ${$bas_com{$keys}}[1] += $g_num;
    ${$bas_com{$keys}}[2] += $all_num;
#    print "sub done $i\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <geno_seq> <DMR> <OUTPUT>
    This is to get G+C base composition distribution throughth DMS cluster
DIE
}
