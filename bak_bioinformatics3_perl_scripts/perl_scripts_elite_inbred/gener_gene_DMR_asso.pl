#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($deg_prefix, $gene_prefix, $dmr, $deg_num, $gene_num) = @ARGV;
my @surfix = ("body", "genic", "down", "up");
foreach(@surfix){
   my $deg_num_dmr = `intersectBed -a $deg_prefix.$_ -b $dmr |wc -l`;
      chomp $deg_num_dmr;
   my $gene_num_dmr = `intersectBed -a $gene_prefix.$_ -b $dmr |wc -l`;
      chomp $gene_num_dmr;
   print "$_\t$deg_num\t$deg_num_dmr\t$gene_num\t$gene_num_dmr\n";
}


sub usage{
    my $die =<<DIE;
    perl *.pl <DEG prefix> <Gene prefix> <DMR region> <DEG number> <gene Number>
DIE
}


