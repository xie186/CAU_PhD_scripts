#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($dup,$pos,$geno)=@ARGV;

open DUP,$dup or die "$!";
my %dup;
while(<DUP>){
    my ($ge1,$ge2)=split;
    $dup{$ge1}++;
    $dup{$ge2}++;
}
open GENO,$geno or die "$!";
my @tem=<GENO>;
my $aa=join'',@tem;
   @tem=split(/>/,$aa);
$aa=0;
my %hash;
foreach(@tem){
    if($_){
        my ($chr,@seq)=split(/\n/,$_);
        chomp @seq;
        $chr=~s/chr//;
        my $sequ=join'',@seq;
        $hash{$chr}=$sequ;
    }
}

open POS,$pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    
    if(exists $dup{$gene}){
        my $tem_seq=substr($hash{$chr},$stt-4000,$end+8000-$stt);
        if($strand eq '-'){
            $tem_seq=reverse $tem_seq;
            $tem_seq=~tr/ATGC/TACG/;
        }
        print ">$gene\n$tem_seq\n";
    }
}
sub usage{
    my $die=<<DIE;
    USAFGE:perl *.pl <DUP> <POS> <Genome>
DIE
}
