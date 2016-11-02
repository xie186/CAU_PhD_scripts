#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($gff,$out)=@ARGV;

open GFF,$gff or die "$!";
open OUT,"+>$out" or die "$!";
while(<GFF>){
    next if /^##/;
    chomp;
    my ($chr,$spec,$ele,$stt,$end,$fei1,$strand,$fei2,$gff_id)=split;
    next if($ele ne "gene");
    $chr = lc $chr;
    $chr =~s/chr//g;
    next if $chr !~ /\d/;
    my ($id,$note,$name)=split(/;/,$gff_id);
       ($id)=(split(/=/,$id))[1];
       ($note)=(split(/=/,$note))[1];
       ($name)=(split(/=/,$name))[1];   
    print OUT "chr$chr\t$stt\t$end\t$name\t$strand\t$note\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <GFF [Arabidopsis][rice]> <OUTPUT>
DIE
}
