#!/usr/bin/perl -w
use strict;
use SVG;
die "Usage:perl *.pl <GeneList><BratResults>\n" unless @ARGV==2;
my ($gene_list,$meth)=@ARGV;
#my %strct;
$meth=~/(rev)/;my $flag="forw";
if($1 && $1 eq "rev"){$flag="rev";}
open LIST,$gene_list or die "$!";
while(my $gene=<LIST>){
    print "Here we go!\n";
    chomp $gene;
    my @geneinfo=split(/\s+/,$gene);
    #get meth information
    open OUT,"+>$geneinfo[0].$flag";
    my @methinfo;
    open METH,$meth or die "$!";
    while(my $me=<METH>){
       chomp $me;
       my @methlation=split(/\s+/,$me);
       $methlation[0]=~s/chr//;
       if($methlation[0] == $geneinfo[1] && $methlation[1]>=$geneinfo[2]-3000 && $methlation[1]<=$geneinfo[3]+3000){
          $methlation[3]=~s/\w+://;
          print OUT "$methlation[0]\t$methlation[1]\t$methlation[2]\t$methlation[3]\t$methlation[4]\t$methlation[5]\n";
       }elsif($methlation[0] == $geneinfo[1] && $methlation[1]>=$geneinfo[2]+3000){
          last;
       }else{
          next;
       }
    }
    close OUT;
}
