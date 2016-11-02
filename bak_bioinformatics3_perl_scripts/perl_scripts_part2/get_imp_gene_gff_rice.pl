#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($imp,$gff) = @ARGV;

open IMP,$imp or die "$!";
my %hash_imp;
while(<IMP>){
    chomp;
   # chr2    MSU_osa1r6      gene    16953627        16955752        .       +       .       LOC_Os02g28660  mat
    my ($chr,$ensembl,$ele,$stt,$end,$dot1,$strand,$dot2,$name) = split;
    $hash_imp{$name} ++;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    #chr1    -       upstream        -97     1902    -       +       -       LOC_Os01g01010.1
    my ($chr,$ensembl,$ele,$stt,$end,$dot1,$strand,$dot2,$trans) = split;
    next if $chr !~ /chr\d+/;
    my ($name,$id) = $trans =~ /(.*)\.(\d+)/;
    next if $id != 1;
    print "$_\n" if exists $hash_imp{$name};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <imp genes> <GFF> 
DIE
}
