#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($vcf1,$vcf2,$inbred) = @ARGV;

open LVCF,$vcf1 or die "$!";
my $head = <LVCF>;
my ($h_chr,$h_pos,$h_ref,@inbred) = split(/\t/,$head);
my $index = "NA";
for(my $i = 0;$i <@inbred; ++$i){
    $index = $i if $inbred eq $inbred[$i];
}
my %hash_lar;
my %hash_ref;
while(<LVCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    ($ref) = $ref =~ /(.*)\/[A-Z]/;
    for(my $i = 0;$i < @geno; ++$i){
        next if ($geno[$index] eq $ref || $geno[$index] =~ /x/i);
        $hash_lar{"$chr\t$pos"} = $geno[$index];
        $hash_ref{"$chr\t$pos"} ++;
    }
}
close LVCF;

open SVCF,$vcf2 or die "$!";
$head = <SVCF>;
($h_chr,$h_pos,$h_ref,@inbred) = split(/\t/,$head);
$index = "NA";
for(my $i = 0;$i <@inbred; ++$i){
    $index = $i if $inbred eq $inbred[$i];
}
while(<SVCF>){
    chomp;
    my ($chr,$pos,$ref,@geno) = split;
    ($ref) = $ref =~ /(.*)\/[A-Z]/;
    my $tem_geno = "NA";
    for(my $i = 0;$i < @geno; ++$i){
            $tem_geno = $geno[$index];
    }
    next if ($tem_geno eq $ref || $tem_geno =~ /x/i);
    if(!exists $hash_lar{"$chr\t$pos"}){
        print "small\t$chr\t$pos\t$ref\t$tem_geno\t\n";
    }else{
        print "both\t$chr\t$pos\t$ref\t$tem_geno\t$hash_lar{\"$chr\t$pos\"}\n";
        delete $hash_lar{"$chr\t$pos"};
    }
}
foreach(keys %hash_lar){
    print "large\t$_\t$hash_ref{$_}\t$hash_lar{$_}\n";
}

sub usage{
    my $die  =<<DIE;
    perl *.pl <vcf1> <vcf2> <inbred> 
DIE
}
