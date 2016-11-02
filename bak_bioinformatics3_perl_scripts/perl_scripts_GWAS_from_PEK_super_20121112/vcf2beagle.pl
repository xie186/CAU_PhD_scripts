#!/usr/bin/perl -w

die usage() unless @ARGV==2;
my ($vcf,$bgl) = @ARGV;
open VCF,$vcf or die "$!";
open BGL,"+>$bgl" or die "$!";
my $i=0;
while(<VCF>){
    chomp;
    if($i>0){
        my ($chr,$pos,$ref,@geno) = split;
        print BGL "M\tsnp$pos";
        foreach my $tem_geno(@geno){
            if($tem_geno =~ /\/|x/){
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
    perl *.pl <VCF> <bgl> 
DIE
}
