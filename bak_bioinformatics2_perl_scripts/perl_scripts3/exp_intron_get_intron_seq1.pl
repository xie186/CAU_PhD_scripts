#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($gff,$geno,$gene_te,$ge_te)=@ARGV;
open GENO,$geno or die "$!";
my @geno=<GENO>;
my $join=join('',@geno);
   @geno=split(/>/,$join);
   shift @geno;
   $join=0;
my $nu=@geno;
my %hash_geno;
for(my $i=0;$i<$nu;++$i){
    my $tem=shift @geno;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $seq=join('',@seq);
    $hash_geno{$chr}=$seq;
}
close GENO;

open GETE,$ge_te or die "$!";
my %hash_ge;
while(<GETE>){
     chomp;
     my ($chr,$stt,$end,$gene,$strand)=split;
     $hash_ge{$gene}++;
}

open GFF,$gff or die "$!";
my %hash_intron;
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
    next if ($chr eq "Mt" || $chr eq "Pt" || $chr eq "UNKNOWN" || $ele ne "intron");
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    $chr="chr".$chr;
    next if !exists $hash_ge{$name};
    next if exists $hash_intron{"$chr\_$ele\_$stt\_$end\_$name"};
    $hash_intron{"$chr\_$ele\_$stt\_$end\_$name"}++;
    my $tem_seq=substr($hash_geno{$chr},$stt-1,$end-$stt+1);
    print ">$chr\_$ele\_$stt\_$end\_$name\n$tem_seq\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <GFF> <genome sequence>  <Genes without TEs within gene region>
DIE
}
