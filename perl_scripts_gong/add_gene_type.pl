#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($cuffdiff, $type) = @ARGV;

my %gene_type;
open TYPE, $type or die "$!";
while(<TYPE>){
    chomp;
    my ($chr,$stt,$end,$id,$strand,$type) = split;
    $gene_type{$id} = $_;
}
open DIFF, $cuffdiff or die "$!";
my $header = <DIFF>;
my ($test_id, $gene_id,$gene, $locus, $sample_1, $sample_2, $status, $value_1, $value_2, $logfc, $test_stat,$p_value,$q_value,$sig) = split(/\t/, $header);
print "chr\tstt\tend\tid\tstrand\ttype\t$sample_1\t$sample_2\t$status\t$value_1\t$value_2\t$logfc\t$test_stat\t$p_value\t$q_value\t$sig";
while(<DIFF>){
    chomp;
    my ($test_id, $gene_id,$gene, $locus, $sample_1, $sample_2, $status, $value_1, $value_2, $logfc, $test_stat,$p_value,$q_value,$sig) = split;
    $test_id =~ s/\.1//g;
    print "$gene_type{$test_id}\t$sample_1\t$sample_2\t$status\t$value_1\t$value_2\t$logfc\t$test_stat\t$p_value\t$q_value\t$sig\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <cuffdiff> <type> 
DIE
}
