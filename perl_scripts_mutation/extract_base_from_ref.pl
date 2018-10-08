#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($snp_pos, $geno) = @ARGV;
open GENO,$geno or die "$!";
my @geno = <GENO>;
my $fasta = join('', @geno);
   @geno = split(/>/, $fasta);
shift @geno;
my %geno_seq;
foreach(@geno){
  my ($chr, @seq) = split(/\n/);
  my $seq = join('', @seq);
  $geno_seq{$chr} = $seq;
}

open SNP,$snp_pos or die "$!";
while(<SNP>){
    next if /^#/;
    chomp;
    my ($line, $chr, $pos) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    my $base = substr($geno_seq{$chr}, $pos-1, 1);
    $chr =~ s/chr//;
    print "$line\t$chr\t$pos\t$base\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp position> <genomic sequences> 
DIE
}
