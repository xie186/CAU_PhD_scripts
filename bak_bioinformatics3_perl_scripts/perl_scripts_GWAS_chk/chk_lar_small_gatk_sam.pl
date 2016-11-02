#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($vcf1,$vcf2) = @ARGV;

open LVCF,$vcf1 or die "$!";
my $head = <LVCF>;
my ($h_chr,$h_pos,$h_ref,@inbred) = split(/\t/,$head);
my %hash_lar;
my %hash_ref;
while(<LVCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    my $tem_geno = join("\t",@geno);
    my $nu = $tem_geno =~ tr/ATGC/ATGC/;
    next if $nu ==0;
    $hash_lar{"$chr\t$pos"} = $_;
    $hash_ref{"$chr\t$pos"} ++;
}
close LVCF;

open SVCF,$vcf2 or die "$!";
$head = <SVCF>;
($h_chr,$h_pos,$h_ref,@inbred) = split(/\t/,$head);
while(<SVCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    my $tem_geno = join("\t",@geno);
    my $nu = $tem_geno =~ tr/ATGC/ATGC/;
    next if $nu ==0;
    if(exists $hash_lar{"$chr\t$pos"}){
        print "both\t$_\n";
        delete $hash_lar{"$chr\t$pos"};
    }else{
        print "small\t$_\n";
    }
}
foreach(keys %hash_lar){
    print "large\t$_\t$hash_ref{$_}\t$hash_lar{$_}\n";
}

sub usage{
    my $die  =<<DIE;
    perl *.pl <vcf1> <vcf2> 
DIE
}
