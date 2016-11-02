#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($tab,$geno)=@ARGV;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
   $join=~s/>//;
   @aa=split(/>/,$join);
my %hash;
my $chr_nu=@aa;
for(my $i=0;$i<=$chr_nu;++$i){
    my $tem_seq=shift @aa;
    next if !$tem_seq;
    my ($chr,@seq)=split(/\n/,$tem_seq);
    chomp @seq;
    $tem_seq=join'',@seq;
    $hash{$chr}=$tem_seq;
}

open TAB,$tab or die "$!";
while(<TAB>){
    chomp;
    my ($id,$len,$copy,$strand,$chr,$pos)=split; 
    my $seq;
    if($strand==0){
        $seq=substr($hash{$chr},$pos-31,100+$len);
    }else{
        $seq=substr($hash{$chr},$pos-71,100+$len);
        $seq=reverse $seq;
        $seq=~tr/ATGC/TACG/;
    }
    print ">t$id\_length-$len\_number-$copy\_$strand\_$chr\_$pos\n$seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Table smRNA> <Genome>
    To get sequence 30 bp upstream,70 downstream of mapped position.
DIE
}
