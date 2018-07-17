#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 8;
my ($fq1, $fq2, $proc_nu, $qual_type, $bowtie, $index, $e_qual, $out)=@ARGV;
open OUT,"+>$out" or die "$!";

if($fq1 =~ /.gz$/){
    my ($tem_fq1, $tem_fq2) = ($fq1, $fq2);
    $fq1 =~ s/\.gz//g;$fq2 =~ s/\.gz//g;
    my $report_gunzip1 = `gunzip -cd $tem_fq1 > $fq1`;
    my $report_gunzip2 = `gunzip -cd $tem_fq2 > $fq2`;
    print OUT "Step 0 :gunzip done!\n======\n$report_gunzip1\n=====$report_gunzip2\n=====\n";
}else{
    print OUT "Step 0 :The file has been gunzipped!\n======\n=====\n";
}

$fq1 =~ s/\.gz//g;
$fq2 =~ s/\.gz//g;
my $report_trim1= `perl ~/software/SolexaQA_1.12/DynamicTrim.pl $fq1`;
my $report_trim2= `perl ~/software/SolexaQA_1.12/DynamicTrim.pl $fq2`;
print OUT "Step 1 :trim done!\n======\n$report_trim1\n$report_trim2\n=====\n";

my $report_len_srt = `perl ~/software/SolexaQA_1.12/LengthSort.pl $fq1.trimmed $fq2.trimmed`;
`rm $fq1 $fq2;rm $fq1.trimmed $fq2.trimmed`;
print OUT "Step 2 :Length sort done!\n======\n$report_len_srt\n=====\n";

if($bowtie eq "bowtie2"){
    my $report_bismark = `~/software/bismark_v0.7.4/bismark --$bowtie -p $proc_nu --$qual_type $index -1 $fq1.trimmed.paired1 -2 $fq1.trimmed.paired2`;
    print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
     my $report_dedu = `perl ~/software/bismark_v0.7.4/deduplicate_bismark_alignment_output.pl -p $fq1.trimmed.paired1_bismark_bt2_pe.sam`;
    print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";

    my $report_methextra = `~/software/bismark_v0.7.4/methylation_extractor -p $fq1.trimmed.paired1_bismark_bt2_pe.sam_deduplicated.sam`;
    print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n";
}else{
     # parametre used in BSR1 paired-end reads:-q --phred64-quals -n 2 -l 28 -e 100 -k 2(default) --best --minins 50 --maxins 550 --chunkmbs 512
    my $report_bismark = `~/software/bismark_v0.7.4/bismark --$qual_type -n 1 -l 25 -e $e_qual $index -1 $fq1.trimmed.paired1 -2 $fq1.trimmed.paired2`;
    print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
    my $report_dedu = `perl ~/software/bismark_v0.7.4/deduplicate_bismark_alignment_output.pl -p $fq1.trimmed.paired1_bismark_pe.sam`;
    print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";

    my $report_methextra = `~/software/bismark_v0.7.4/methylation_extractor -p $fq1.trimmed.paired1_bismark_pe.sam_deduplicated.sam`;
    print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <reads1> <reads2> <process number> <quality type [phred33-quals] [phred64-quals]> <bowtie1 or 2> <geno_index> <-e [100 or]> <report file> 
    one fastq file!
DIE
}
