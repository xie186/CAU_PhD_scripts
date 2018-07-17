#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($anno,$deg) = @ARGV;
open ANNO,$anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,$annotation) = split(/\t/, $_, 2);
    ($gene) = split(/\./, $gene);
    $gene_anno{"$gene"} = $annotation;
}
close ANNO;

print "chr\tstt\tend\tid\tstrand\ttype\tsample_1\tsample_2\tstatus\tvalue_1\tvalue_2\tlog2(fold_change)\ttest_stat\tp_value\tq_value\tsignificant\tType\tShort_description\tCurator_summary\tComputational_description\n";
open DEG,$deg or die "$!";
while(<DEG>){
    chomp;
    next if /type/;
    my ($chr,$stt,$end,$gene) = split;
    print "$_\t$gene_anno{$gene}\n";
}
close DEG;

sub usage{
    my $die =<<DIE;
    perl *.pl <anno> <DEG> 
DIE
}
