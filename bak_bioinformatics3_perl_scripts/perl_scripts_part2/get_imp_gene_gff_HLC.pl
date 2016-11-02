#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($imp,$gff,$hlc_gene) = @ARGV;

open HLC,$hlc_gene or die "$!";
my %hlc_name;
while(<HLC>){
     chomp;
     my ($name) = split;
     $hlc_name{$name} ++;
}

open SYN,$imp or die "$!";
my %hash_imp;
while(<SYN>){
    chomp;
    my ($name) = split;
    $hash_imp{$name} ++ if exists $hlc_name{$name};
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    #9       ensembl gene    66347   68582   .       -       .       ID=GRMZM2G354611;Name=GRMZM2G354611;biotype=protein_coding
    $_ =~ s/FGT/FG/g;
    next if !/^\d/;
    my ($chr,$ensembl,$ele,$stt,$end,$dot1,$strand,$dot2,$name) = split;
    if($ele eq "gene"){
        ($name) = $name=~ /ID=(.*);Name=/;
        print "$_\n" if exists $hash_imp{$name};
    }elsif($ele eq "upstream" || $ele eq "downstream"){
        #Parent=GRMZM5G833275;Name=
        ($name) = $name =~ /Parent=(.*);Name=/;
        print "$_\n" if exists $hash_imp{$name};
    }elsif($ele =~ /exon/ || $ele =~ /intron/){
        ($name) = $name =~ /Parent=(.*);Name=/;
        ($name) = split(/_/, $name) if $name =~ /GRMZM/;
        print "$_\n" if exists $hash_imp{$name};
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <imp genes> <GFF> <HLC gene>
DIE
}
