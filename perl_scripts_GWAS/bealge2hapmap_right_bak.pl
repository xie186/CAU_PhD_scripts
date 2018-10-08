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
    my @tem_geno;
    for(my $i =0 ;$i<$#geno;$i+=2){
        my $tem = $geno[$i].$geno[$i];
        push @tem_geno,$tem;
    }
    my $tem_geno = join("\t",@tem_geno);
#       $tem_geno =~ s/A\tA/AA/g;
#       $tem_geno =~ s/C\tC/CC/g;
#       $tem_geno =~ s/G\tG/GG/g;
#       $tem_geno =~ s/T\tT/TT/g;
       $pos =~ s/snp//g;
    print OUT "snp$pos\t-\t$chrom\t$pos\t+\tv2\tCAU\tSBS\tBREED\tSECOND\tQC+\t$tem_geno\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmpa> <bealge file> <output>
DIE
}
