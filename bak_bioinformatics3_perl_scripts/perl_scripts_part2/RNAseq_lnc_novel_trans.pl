#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($iso,$len_cut,$fpkm_cut) = @ARGV;
open ISO,$iso or die "$!";
my %hash_exclu;
<ISO>;
while(<ISO>){
    chomp;
    my ($iso_id,$dot1,$dot2,$gene_id,$dot3,$dot4,$coor,$len,$fpkm) = split;
    $hash_exclu{$gene_id} ++ if $iso_id =~ /^en/;
}
close ISO;

open ISO,$iso or die "$!";
<ISO>;
while(<ISO>){
     chomp;
     my ($iso_id,$dot1,$dot2,$gene_id,$dot3,$dot4,$coor,$len,$fpkm) = split;
     next if ($len <=$len_cut || $fpkm <=$fpkm_cut);
     my ($chr,$stt,$end) = $coor=~/(chr\d+):(\d+)-(\d+)/;
     if(!exists $hash_exclu{$gene_id}){
#         print "$_\n";
         print "$chr\t$stt\t$end\t$iso_id\t$gene_id\n";
     }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <isoform> <lenth cutoff> <fpkm cut off>
DIE
}
