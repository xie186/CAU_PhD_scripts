#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($module, $rpkm, $out) = @ARGV;
open MOD,$module or die "$!";
<MOD>;
my %hash_clus;
my %hash_clus_name;
while(<MOD>){
    chomp;
    $_ =~ s/"//g;
    my ($gene_num, $clus_num) = split(/,/,$_);
    $hash_clus{$gene_num} = $clus_num;
    $hash_clus_name{$clus_num} ++;
}
close MOD;

print "$module: done\n";
my @clus = sort{$a<=>$b} keys %hash_clus_name;

open OUT,"+>$out" or die "$!";
open RPKM,$rpkm or die "$!";
<RPKM>;
my $num = 1;
my %gene_clus;
while(<RPKM>){
    my ($gene) = split;
    print OUT "$gene\t$hash_clus{$num}\n";
    ++$num;
}
close RPKM;
close OUT;
print "$rpkm: done\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <module> <rpkm> <out>
DIE
}
