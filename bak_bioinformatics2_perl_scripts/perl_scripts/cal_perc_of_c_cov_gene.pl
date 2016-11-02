#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($methy,$geno,$genepos,$chrom)=@ARGV;

open BED,$methy or die "$!";
my %methy_info;
while(<BED>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$lev)=split;
    next if $depth<3;
    $methy_info{"$pos1"}=$lev;
}

open GENO,$geno or die "$!";
my @tem=<GENO>;
shift @tem;
chomp @tem;
my $seq=join '',@tem;
@tem=(0);

open GENE,$genepos or die "$!";
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$name,$strands)=split;
    next if $chr ne $chrom;
    my $seq_tem=substr($seq,$stt-1,$end-$stt+3);
    my $cg_nu=$seq_tem=~s/CG/CG/g;
       next if $cg_nu==0;
    my $meth_nu=0;
    for(my $i=$stt;$i<=$end;++$i){
        $meth_nu++ if (exists $methy_info{$i});
    }
    my $perc=$meth_nu/$cg_nu;
    print "$name\tCpG\t$cg_nu\t$perc\n";
}


sub usage{
    my $die=<<DIE;

    perl *.pl <Bedgraph File> <Genome single> <Gene position> <Chromosome number>
    we use this script to calcuate the percent of Cs covered by criteria as below:
    1) reads depth >=3;

DIE
}
