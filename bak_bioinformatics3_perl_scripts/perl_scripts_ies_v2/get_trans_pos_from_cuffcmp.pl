#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($cmp_loci,$cmp_track) = @ARGV;
open LOCI,$cmp_loci or die "$!";
my %hash_loci;
while(<LOCI>){
    chomp;
    my ($gene_id,$pos,$ref_gene,$tis1,$tis2,$tis3,$tis4)  = split;
    next if  $pos !~ /^chr\d/;
    my ($chr,$strand,$stt,$end)= $pos =~ /(chr\d+)\[(.*)\](\d+)-(\d+)/; 
    my $flag=0;
    if($tis1 ne "-" && $tis2 ne "-"){ #  expressed in en_BM_10DAP and en_MB_10DAP 
        $flag += 1;
    }
    if($tis3 ne "-" && $tis4 ne "-"){ #   expressed in en_BM_12DAP and en_MB_12DAP
        $flag += 2;
    }
    $hash_loci{$gene_id} = "$chr\t$stt\t$end\t$strand\t$flag";
}

open TRACK,$cmp_track or die "$!";
while(<TRACK>){
    chomp;
    my ($trans_id,$gene_id,$ref_gene,$class_code,$tis1,$tis2,$tis3,$tis4) = split;
    print "$hash_loci{$gene_id}\t$gene_id\t$ref_gene\t$class_code\n" if exists $hash_loci{$gene_id};
}

sub usage{
    print <<DIE;
    perl *.pl <cuff compare loci> <cuff compare tracking> 
DIE
    exit 1;
}
