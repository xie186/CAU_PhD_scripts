#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($geno,$region) = @ARGV;

open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
   @aa=split(/>/,$join);
$join=@aa; #chromosome number
my %hash;
for(my $i=1;$i<=$join;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $hash{$chr}=$tem_seq;
}

open REG,"grep 'region' $region|" or die "$!";
while(<REG>){
    chomp;
    ##row_number    region  chr1    99767965        99783203        1       0
    my ($pheno,$region,$chr,$stt,$end,$snp_nu,$gene_nu) = split;
    next if $gene_nu != 0;
    $pheno =~ s/#//g;
    my $tem_seq = substr($hash{$chr}, $stt - 1, $end - $stt + 1);
    print ">$pheno\_$region\_$chr\_$stt\_$end\n$tem_seq\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <Genome> <regions> 
DIE
}
