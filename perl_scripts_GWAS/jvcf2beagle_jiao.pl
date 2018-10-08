#!/usr/bin/perl -w

die usage() unless @ARGV==2;
my ($jvcf,$bgl) = @ARGV;
my $vcf = $jvcf;
   $vcf = "zcat $jvcf|" if $jvcf =~ /gz$/;
open VCF,"$vcf" or die "$!";
open BGL,"+>$bgl" or die "$!";
my $i=0;
while(<VCF>){
    chomp;
    if($i>0){
        my ($chr,$pos,$ref,@geno) = split;
        print BGL "M\tsnp$pos";
        foreach my $tem_geno(@geno){
            if($tem_geno =~ /x/i){
                print BGL "\t?\t?";
            }else{
                print BGL "\t$tem_geno\t$tem_geno";
            }
        }
        print BGL "\n";
    }
    ++$i;
}

sub usage{
    my $die = <<DIE;
    perl *.pl <JVCF> <bgl> 
    This scripts was revised from jiao scripts.
DIE
}
