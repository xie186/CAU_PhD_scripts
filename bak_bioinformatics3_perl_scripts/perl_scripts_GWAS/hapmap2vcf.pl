#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($vcf,$hap) = @ARGV;

open VCF,$vcf or die "$!";
open HAP,"+>$hap" or die "$!";
my $header = <VCF>;
my ($chr,$pos,$b73,@inbred) = split(/\t/,$header);
my $inbred = join("\t",@inbred);
print HAP "rs\talleles\tchrom\tpos\tstrand\tassembly\tcenter\tprotLSID\tassayLSID\tpanel\tQCcode\t$inbred";
while(<VCF>){
    chomp;
    my ($chr,$pos,$alle,@geno) = split;
    my $geno = join("\t",@geno);
       $geno =~ s/\w\/\w/NN/g;
       $geno =~ s/x/NN/g;
       $geno =~ s/A/AA/g;
       $geno =~ s/T/TT/g;
       $geno =~ s/G/GG/g;
       $geno =~ s/C/CC/g;
    print HAP "$chr\_$pos\t$alle\t$chr\t$pos\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$geno\n";
}

sub  usage{
    print <<DIE;
    perl *.pl <vcf file> <OUT hapmap>
DIE
    exit 1;
}
