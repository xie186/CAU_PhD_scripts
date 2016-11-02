#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($hapmap,$bgl,$out) = @ARGV;
open HAP,$hapmap or die "$!";
chomp (my $head = <HAP>);
my @head = split(/\t/,$head);
splice(@head,0,11);

open OUT,"+>$out" or die "$!";
print OUT "$head\n";
open BGL,"zcat $bgl |" or die "$!";
<BGL>;
while(<BGL>){
    chomp;
    my ($m,$coor,@geno) = split;
    my ($tem_snp,$chrom,$pos) = split(/_/,$coor);
    my @tem_geno ;
    foreach my $tem_geno(@geno){
        $tem_geno .=$tem_geno;
        push @tem_geno,"$tem_geno";
    }
    my $tem_geno = join("\t",@tem_geno);
       $pos =~ s/snp//g;
    print OUT "snp$pos\t-\t$chrom\t$pos\t+\tv2\tCAU\tSBS\tBREED\tSECOND\tQC+\t$tem_geno\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmpa> <bealge file> <output>
DIE
}
