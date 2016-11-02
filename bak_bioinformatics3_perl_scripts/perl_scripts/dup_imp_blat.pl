#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($gene_pos,$geno,$dup_pair,$imp)=@ARGV;
open POS,$gene_pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $chr=0 if /^UN/;
    $chr="chr".$chr;
    $hash{$gene}="$chr\t$stt\t$end\t$gene\t$strand";
}

open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
   $join=~s/>//;
@aa=split(/>/,$join);
$join=0;
my $nu=@aa;
my %geno_seq;
foreach(@aa){
    my ($chr,@seq)=split(/\n/,$_);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $geno_seq{$chr}=$tem_seq;
    $tem_seq=0;
    undef @seq;
}

open PAIR,$dup_pair or die "$!";
while(<PAIR>){
    chomp;
    my ($gene1,$gene2)=(split(/\s+/))[-3,-2];
    my ($chr1,$stt1,$end1,$ge1,$strd1)=split(/\t/,$hash{$gene1});
    my ($chr2,$stt2,$end2,$ge2,$strd2)=split(/\t/,$hash{$gene2});
    my $seq1=substr($geno_seq{$chr1},$stt1-2001,$end1-$stt1+4001);
    my $seq2=substr($geno_seq{$chr2},$stt2-2001,$end2-$stt2+4001);
    open GE1,"+>$imp.$ge1.fa" or die "$!";
    print GE1 ">$ge1\n$seq1\n";
    open GE2,"+>$imp.$ge2.fa" or die "$!";
    print GE2 ">$ge2\n$seq2\n";
    my $report=`blat $imp.$ge1.fa $imp.$ge2.fa $imp.$ge2.2.$ge1.blat8 -out=blast`;
    print "$report\n";
}

sub usage{
    my $die=<<DIE;

    perl *.pl  <Gene position> <Genome> <Duplicate pairs> <[MEG][PEG]>

DIE
}
