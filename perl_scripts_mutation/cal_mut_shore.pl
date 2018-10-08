#!/usr/bin/perl -w 
use strict;

die usage() unless @ARGV == 4;
my ($control_ref, $vcf, $depth_lim, $out) = @ARGV;

my ($min_dep, $max_dep) = split(/:/, $depth_lim);

open OUT, "+>$out" or die "$!";
print OUT "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tT1_geno\tT1_tot_depth\tT1_dep_ref\tT1_dep_alt\n";
#CHROM  POS    ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  infor
open VCF, $vcf or die "$!";
my %rec_var;
while(<VCF>){
    chomp;
    next if (/^#/ ||!/PASS/);
    my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $infor, $format, $mut) = split;
    my @mut = split(/:/, $mut);
    my ($geno,$dep, $dep_ref, $dep_alt) = ($mut[0], $mut[2], split(/,/, $mut[1]));
    if($mut =~ /1\/1/ && $dep > $min_dep && $dep < $max_dep &&  $dep_ref == 0){
         $rec_var{"$chr\t$pos"} = "$chr\t$pos\t$id\t$ref\t$alt\t$qual\t$filter\t$geno\t$dep\t$dep_ref\t$dep_alt";
    }
}
close VCF;

my $num = () = split(/:/, $control_ref);
$control_ref =~ s/:/ /g;
my %var_ref_chk;

print "REP: starting check reference genome!\n";
open REF, "xzcat $control_ref |" or die "$!";
while(<REF>){
     next if /#/;
     #SCI0426 chr1    103786  T       T       40      90      0.989011        1 
     my ($sam, $chr,$pos,$ref, $geno, $na1, $dep, $re, $na2) = split;
     if(exists $rec_var{"$chr\t$pos"} && $dep > $min_dep && $dep < $max_dep){
         $var_ref_chk{"$chr\t$pos"} ++;
     }
}
close REF;
print "REP: Finished!\n";
print "REP: Now trying to output the results!\n";
foreach(keys %rec_var){
    if(exists $var_ref_chk{$_} && $var_ref_chk{$_} ==  $num){
        print OUT "$rec_var{$_}\n";
    }
}
print "REP: Finished!\n";
sub usage{
    my $die = <<DIE;
    perl *.pl <ref shore file [file1:file2]> <vcf raw variant>  <depth Limitation [min:max]> <out file> 
DIE
}
