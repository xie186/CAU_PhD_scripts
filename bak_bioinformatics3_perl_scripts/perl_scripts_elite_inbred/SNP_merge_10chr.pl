#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($real_name,$vcf_file) = @ARGV;
open NAME,$real_name or die "$!";
my %hash_inbred;
while(<NAME>){
    chomp;
    my ($dot,$cau_acc,$inbred_name) = split;
    $hash_inbred{$cau_acc} = $inbred_name;
}

my @vcf = split(/,/,$vcf_file);

open VCF,$vcf[0] or die "$!";
##CHROM  POS     REF     CAU1    CAU4    CAU5    CAU27
my $header = <VCF>;
$header = &chg_header($header);
print "$header\n";
close VCF;

foreach my $vcf(@vcf){
    open VCF,$vcf or die "$!";
    while(my $line = <VCF>){
        chomp $line;
        next if ($line =~ /X/ || $line =~ /#/);
        my ($chr,$pos,$ref_alt,@geno) = split(/\t/,$line);
           ($ref_alt) = split(/\//,$ref_alt);
           ($line) = join("\t",($chr,$pos,$ref_alt,@geno));
        print "$line\n"; 
    }
}

sub chg_header{
    my ($tem_header) = @_;
       chomp $tem_header;
    my ($chr,$pos,$alt,@inbred) = split(/\t/,$tem_header);
    for (my $i = 0; $i < @inbred; ++$i){
        my $cau_acc = $inbred[$i];
        $inbred[$i] =~ s/$cau_acc/$hash_inbred{$cau_acc}/;
    }
       $tem_header = join("\t",($chr,$pos,$alt,@inbred));
    return $tem_header;
}
sub usage{
    my $die =<<DIE;
    perl *.pl <real inbred name> <vcf1,vcf2,vcf3>
DIE
}
