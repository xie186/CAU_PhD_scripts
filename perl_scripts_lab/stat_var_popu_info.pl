#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($file, $popu_vari, $out) = @ARGV;

open VAR,$popu_vari or die "$!";
my %geno_var;
while(<VAR>){
    chomp;
    next if /pos/;
    my ($chr, $pos, $geno, $base) = split(/\t/, $_, 4);
    my ($ref, $alt)  = split (/\//, $geno);
    next if $alt !~ /A|T|G|C/;
    my %hash=("A" => 0, "T" => 0, "G" => 0, "C" => 0);
    $hash{"A"} = $base =~ tr/A/A/;
    $hash{"T"} = $base =~ tr/T/T/;
    $hash{"G"} = $base =~ tr/G/G/;
    $hash{"C"} = $base =~ tr/C/C/;
    my $freq = $hash{"$ref"} / ($hash{"$ref"} + $hash{"$alt"});
    $freq = 1- $freq if $freq > 0.5;
    #print "$ref\t$alt\t$freq\n";
    $geno_var{"$chr\t$pos"} = "$ref\t$alt\t$freq";
}
close VAR;

open OUT, "+>$out" or die "$!";
open TEM, "$file" or die "$!";
    #chr    pos     ref     alt     qual    effect  impact  gene_name       id      sample  annotation
    my ($var_tot, $popu_var) = (0, 0);
    while(my $line = <TEM>){
         chomp $line;
         #next if $line =~ /MODIFIER/;
         my ($chr,$pos, $ref,$alt, $qual, $effect, $impact, $gene, $trans, $sample, $type, $sim_anno, $Curator_summary) = split(/\t/, $line);
         my $res = "NA";
         $var_tot ++;
         if(exists $geno_var{"$chr\t$pos"}){
             my ($ref1, $alt1) = split(/\t/, $geno_var{"$chr\t$pos"});
             if($alt eq $alt1){
                 $popu_var ++;
                 print OUT "$chr\t$pos\t$ref\t$alt\t$res\t$geno_var{\"$chr\t$pos\"}\n";
             }
         }
}
close TEM;
print "$var_tot\t$popu_var\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <popu_vari> <out>
DIE
}
