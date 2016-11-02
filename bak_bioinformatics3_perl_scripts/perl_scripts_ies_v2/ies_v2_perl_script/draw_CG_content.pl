#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($geno,$gene)=@ARGV;

open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    my ($chr,$pos1,$pos2,$gene,$strand,$imp)=split;
    my $seq_sub=&getseq($chr,$pos1,$pos2,$gene,$strand);
    my $len=length $seq_sub;
    open OUT,"+>$gene.GC_conten.txt";
    open R,"+>plot.R" or die "$!";
    for(my $i=0;$i<=$len/50;++$i){
        my $tem_seq=substr($seq_sub,$i*50,100);
        my $c=$tem_seq=~s/C/C/g;
        my $g=$tem_seq=~s/G/G/g;
        my $cg=$c+$g;
        print OUT "$gene\t$i\t$cg\n";
    }
    my $abline2=$len/50-60;
    my $x_text=$len/100;
    print R "cc<-read.table('$gene.GC_conten.txt')\npdf('$gene.pdf')\nplot(cc[,2],cc[,3],type='l',col='red')\nabline(v=60)\nabline(v=$abline2)\ndev.off()\n";
    system `R --vanilla --slave <plot.R`;
}

sub getseq{
    my ($chr,$pos1,$pos2,$gene,$strand)=@_;
    $chr=">chr".$chr;
    my $seq_chr;
    open GENO,$geno or die "$!";
    while(my $line=<GENO>){
        chomp $line;
        if($chr eq $line){
            while(my $tem=<GENO>){
                chomp $tem;
                last if $tem=~/>/;
                $seq_chr.=$tem;
            }
       }
    }
    my $seq_sub=substr($seq_chr,$pos1-3001,$pos2-$pos1+6001);
    if($strand eq "-"){
        $seq_sub=reverse $seq_sub;
        $seq_sub=~tr/[ATGC]/[ATGC]/;
    }
    return $seq_sub;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <Imp_gene_pos>
DIE
}

