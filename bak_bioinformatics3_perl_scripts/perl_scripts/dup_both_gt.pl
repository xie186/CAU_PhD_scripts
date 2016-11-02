#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($dup_sd,$dup_endo,$fc)=@ARGV;
open SD,$dup_sd or die "$!";
my %hash_gt;
while(<SD>){
    chomp;
    my ($id_block,$id,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    next if ($rpkm1==0 && $rpkm2==0);
    my ($tem1,$tem2)=sort{$a<=>$b}($rpkm1,$rpkm2);
#    next if $tem2/($tem1+0.0000001)<$fc;
    if($rpkm1-$rpkm2>0){
        $hash_gt{"$gene1\t$gene2"}=$_;
    }elsif{
        $hash_ls{"$gene2\t$gene2"}=$_;
    }
}

open ENDO,$dup_endo or die "$!";
while(<ENDO>){
    chomp;
    my ($id_block,$id,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    if($rpkm1-$rpkm2>0){
         exists $hash{"$gene1\t$gene2"};
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Duplicated seedlings> <duplicate endo> <3>
DIE
}
