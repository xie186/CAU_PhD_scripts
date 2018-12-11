#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <genepos><neighborpos><out>" unless @ARGV==2;

open GEPOS,$ARGV[0] or die;

while(my $gene=<GEPOS>){
    next if $gene=~/^UNKNOW/;
    chomp $gene;
    my ($chr1,$stt,$end)=(split(/\s+/,$gene));
    
    open NEPOS,$ARGV[1] or die;
    while(my $nei1=<NEPOS>){
         my $nei2=<NEPOS>;
         chomp $nei1;
         chomp $nei2;
         my ($chra,$stta,$enda,$gene_name)=(split(/\s+/,$nei1));
         my ($chrb,$sttb,$endb)=(split(/\s+/,$nei2));
         if($chra!=$chr1){
             next;
         }elsif($stt>=$stta-10000 && $end<=$endb+10000 && $stt!=$stta && $stt!=$sttb){
             open OUT,"+>>nei_$gene_name" or die;
             print OUT "$gene\n";
             close OUT;
         }else{
             next;
         }
        
    }
}


