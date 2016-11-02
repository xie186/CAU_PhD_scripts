#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($fq1,$qual_type, $index,$bismark_version, $e_qual,$out)=@ARGV;
open OUT,"+>$out" or die "$!";

if( -e $fq1){
    my $report_gunzip = `gunzip $fq1`;
    print OUT "Step 0 :gunzip done!\n======\n$report_gunzip\n=====\n";
}else{
    print OUT "Step 0 :The file has been gunzipped!\n======\n=====\n";
}

$fq1 =~ s/\.gz//g;
#my $report_trim= `perl /NAS1/software/SolexaQA_1.12/DynamicTrim.pl $fq1`;
#print OUT "Step 1 :trim done!\n======\n$report_trim\n=====\n";

#my $report_len_srt = `perl /NAS1/software/SolexaQA_1.12/LengthSort.pl $fq1.trimmed`;
#print OUT "Step 2 :Length sort done!\n======\n$report_len_srt\n=====\n";

my $report_bismark = `/NAS1/software/$bismark_version/bismark --$qual_type -n 2 -l 25 -e $e_qual $index $fq1.trimmed.single`;
print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
my $report_dedu = `perl /NAS1/software/$bismark_version/deduplicate_bismark_alignment_output.pl -s $fq1.trimmed.single_bismark.sam`;
print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";
my $report_methextra = `/NAS1/software/$bismark_version/methylation_extractor -s $_.trimmed.single_bismark.sam_deduplicated.sam`;
print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n"; 

sub usage{
    my $die=<<DIE;
    perl *.pl <single reads> <quality type [phred33-quals] [phred64-quals]> <reference index> <bismark version [bismark_v0.7.7]> <-e [100 or]> <report file> 
    one fastq file!
DIE
}
