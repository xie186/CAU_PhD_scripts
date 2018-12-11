#!/usr/bin/perl -w
use strict;

die "\n",usage(),"\n" unless @ARGV==4;
my ($pos,$name,$geno,$out)=@ARGV;

my %hash;
open POS,$pos or die;
while(<POS>){
    chomp;
    my @aa=split;
    $hash{$aa[3]}=[$aa[0],$aa[1],$aa[2],$aa[3],$aa[4]];
}
close POS;

open GENO,$geno or die;
my @cgeno=<GENO>;
my $join=join '',@cgeno;
   @cgeno=split(/>/,$join);
my %geno;
foreach(@cgeno){
    my @sin=split(/\n/,$_);
    chomp @sin;
    my $chr=shift @sin;
    my $seq=join('',@sin);
    $geno{$chr}=$seq if ($seq && $chr);
    print "$chr\n";
}

open OUT,"+>$out" or die;
open NAME,$name or die;
while(<NAME>){
    chomp;
    if(exists $hash{$_}){
       my $seq_tem=substr($geno{"chr${$hash{$_}}[0]"},${$hash{$_}}[1]-1,${$hash{$_}}[2]-${$hash{$_}}[1]+1);
       if(${$hash{$_}}[-1] eq "-"){
           $seq_tem=reverse $seq_tem;
           $seq_tem=~tr/[ATGC]/[TACG]/;
       }
       print OUT ">$_\n$seq_tem\n";
    }
}
close OUT;

sub usage{
    my $die=<<DIE;
    perl *.pl <gene_pos> <gene_name> <geno> <Out_put>
DIE
}

