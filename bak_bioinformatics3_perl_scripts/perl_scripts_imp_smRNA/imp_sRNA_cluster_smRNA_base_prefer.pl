#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($smRNA_bm, $smRNA_mb,$imp,$lap) = @ARGV;
open BM,$smRNA_bm or die "$!";
my %hash_seq_bm;
while(my $id = <BM>){
    chomp $id;
    $id =~ s/>//;
    my $seq = <BM>;
    $hash_seq_bm{$id} = $seq;
}
close BM;
open MB,$smRNA_mb or die "$!";
my %hash_seq_mb;
while(my $id = <MB>){
    chomp $id;
    $id =~ s/>//;
}
close MB;

open IMP,$imp or die "$!";
my %hash;
while(<IMP>){
    chomp;
    my ($chr,$stt,$end) = split;
    $hash{"$chr\t$stt\t$end"} ++;
}

my $flag = 0;
my %hash_smRNAbm;
my %hash_smRNAmb;
open LAP, $lap or die "$!";
while(<LAP>){
    chomp;
    my ($chr1,$stt1,$end1,$smrna1,$chr2,$stt2,$end2,$smrna2,$lap_nu2,$chr3,$stt3,$end3,$smrna3,$lap_nu3,$chr4,$stt4,$end4,$smrna4,$lap_nu4) = split;
    my @aa = sort {$a<=>$b} ($stt1,$end1,$stt2,$end2,$stt3,$end3,$stt4,$end4);
    if(exists $hash{"$chr1\t$aa[0]\t$aa[-1]"}){
        ++$flag;
#        my $tem_join = join(';',($smrna1,$smrna3));
        my @tem_smRNA = split(/;/,$smrna1);
        foreach my $tem(@tem_smRNA){
           $hash_smRNAbm{$tem} ++;
        }
           @tem_smRNA = split(/;/,$smrna3);
        foreach my $tem(@tem_smRNA){
           $hash_smRNAmb{$tem} ++;
        }
    }
}

foreach(keys %hash_smRNAbm){
    print ">$_\n$hash_seq_bm{$_}";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <smRNA seq BM> <smRNA seq MB> <imprinted smRNA> <Lap>  
DIE
}
