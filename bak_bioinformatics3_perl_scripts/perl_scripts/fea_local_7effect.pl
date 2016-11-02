#!/usr/bin/perl -w
use strict;use DBI;
die usage() unless @ARGV==5;
my ($geno,$cut_depth,$cut_lev,$forw,$out)=@ARGV;
die "$out exists !!!" if -e $out;
open GENO,$geno or die "$!";
my @tem=<GENO>;
chomp @tem;
my $chr=shift @tem;
   $chr=~s/>//;
my $seq=join'',@tem;
my %seven;
open FORW,$forw or die "$!";
my $i=1;
while(<FORW>){
    chomp;
    my ($chr_tem,$pos1,$pos2,$depth,$lev)=split;
    next if (($chr_tem ne $chr) || ($depth<=$cut_depth) ||$lev<=$cut_lev);
    my $seq_tem=substr($seq,$pos1-6,12);
       print  ">$i\n$seq_tem\n";
       ++$i;
       my @split=split(//,$seq_tem);
       for(my $j=-5;$j<=6;++$j){
            ${$seven{$j}}[0]++ if $split[$j+5] eq 'A';
            ${$seven{$j}}[1]++ if $split[$j+5] eq 'T';
            ${$seven{$j}}[2]++ if $split[$j+5] eq 'G';
            ${$seven{$j}}[3]++ if $split[$j+5] eq 'C';
       }
}

open OUT,"+>$out" or die "$!";
print OUT "Pos\tA\tT\tG\tC\n";
foreach(sort{$a<=>$b}keys %seven){
    ${$seven{$_}}[0]=0 if ! ${$seven{$_}}[0];
    ${$seven{$_}}[1]=0 if ! ${$seven{$_}}[1];
    ${$seven{$_}}[2]=0 if ! ${$seven{$_}}[2];
    ${$seven{$_}}[3]=0 if ! ${$seven{$_}}[3];
    print OUT "$_\t${$seven{$_}}[0]\t${$seven{$_}}[1]\t${$seven{$_}}[2]\t${$seven{$_}}[3]\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <depth cutoff> <methylation level cut>  <Forward> <Output>
   
DIE
}
