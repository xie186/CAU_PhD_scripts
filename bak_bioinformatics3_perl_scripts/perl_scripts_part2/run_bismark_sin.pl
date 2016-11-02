#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 7;
my ($fq1,$proc_nu,$qual_type, $index,$bowtie, $e_qual,$out)=@ARGV;
open OUT,"+>$out" or die "$!";

if( -e $fq1){
    my $report_gunzip = `gunzip $fq1` if $fq1 =~ /gz$/;
    print OUT "Step 0 :gunzip done!\n======\n$report_gunzip\n=====\n" if $fq1 =~ /gz$/;
}else{
    print OUT "Step 0 :The file has been gunzipped!\n======\n=====\n";
}

$fq1 =~ s/\.gz//g;
my $report_trim= `perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $fq1`;
print OUT "Step 1 :trim done!\n======\n$report_trim\n=====\n";


my $report_len_srt = `perl /NAS1/software/SolexaQA_1.12/LengthSort.pl $fq1.trimmed`;
print OUT "Step 2 :Length sort done!\n======\n$report_len_srt\n=====\n";

`rm $fq1.trimmed`;

if($bowtie eq "bowtie2"){
    my $report_bismark = `/NAS1/software/bismark_v0.7.4/bismark --bowtie2 -p $proc_nu --$qual_type $index $fq1.trimmed.single`;
    print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
    my $report_dedu = `perl /NAS1/software/bismark_v0.7.4/deduplicate_bismark_alignment_output.pl -s $fq1.trimmed.single_bt2_bismark.sam`;
    print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";
    my $report_methextra = `/NAS1/software/bismark_v0.7.4/methylation_extractor -s $fq1.trimmed.single_bt2_bismark.sam_deduplicated.sam`;
    print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n";
}else{
    my $report_bismark = `/NAS1/software/bismark_v0.7.4/bismark --$qual_type -n 2 -l 25 -e $e_qual $index $fq1.trimmed.single`;
    print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
    my $report_dedu = `perl /NAS1/software/bismark_v0.7.4/deduplicate_bismark_alignment_output.pl -s $fq1.trimmed.single_bismark.sam`;
    print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";
    my $report_methextra = `/NAS1/software/bismark_v0.7.4/methylation_extractor -s $fq1.trimmed.single_bismark.sam_deduplicated.sam`;
    print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <single reads> <process number> <quality type [phred33-quals] [phred64-quals]> <reference index> <bowtie 1 or 2> <-e [100 or]> <report file> 
    one fastq file!
DIE
}
