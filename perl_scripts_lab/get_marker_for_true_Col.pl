#!/usr/bin/perl -w 
use strict;

die usage() unless @ARGV == 2;
my ($vcf, $geno) = @ARGV;

my %hash_var;
my @vcf = split(/,/, $vcf);
foreach(@vcf){
    open VCF, $_ or die "$!";
    while(my $line = <VCF>){
        next if $line =~ /^#/;
        chomp $line; 
        my ($chr,$pos,$id,$ref,$alt,$qual,$filter,$T1_geno,$T1_tot_depth,$T1_dep_ref,$T1_dep_alt,$T2_geno,$T2_tot_depth,$T2_dep_ref,$T2_dep_alt) = split(/\t/, $line);
        push @{$hash_var{"$chr\t$pos"}}, "$T1_geno,$T1_tot_depth,$T1_dep_ref,$T1_dep_alt:$T2_geno,$T2_tot_depth,$T2_dep_ref,$T2_dep_alt";
    }
}

my %geno_seq;
$/="\n>";
open GENO,$geno or die "$!";
while(<GENO>){
    chomp;
    $_ =~ s/>//;
    my ($chr,@seq) =split(/\n/);
    my $seq = join("", @seq);
    $geno_seq{$chr} = $seq;
}

foreach(sort keys %hash_var){
    my @alle_info = @{$hash_var{$_}};
    next if @alle_info != 3;
    my ($chr, $pos) = split(/\t/, $_);
    my $seq = substr($geno_seq{$chr}, $pos -251, 501);
    my $alle_info = join("=", @alle_info);
    print ">$chr\_$pos\t$alle_info\n$seq\n";
}


sub usage{
    my $die = <<DIE;
    perl *.pl <vcf raw variant [vcf1,vcf2]> <geno>
DIE
}
