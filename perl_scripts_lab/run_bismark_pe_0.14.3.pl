#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 9;
my ($fq1, $fq2, $proc_nu, $qual_type, $bowtie, $index, $e_qual, $alias, $out)=@ARGV;
open OUT,"+>$out" or die "$!";

$fq1 =~ s/,/ /g;
$fq2 =~ s/,/ /g;
if($fq1 =~ /.gz$/){
    my $report_gunzip1 = `gunzip -cd $fq1 > $alias\_R1.fq`;
    my $report_gunzip2 = `gunzip -cd $fq2 > $alias\_R2.fq`;
    print OUT "Step 0 :gunzip done!\n======\n$report_gunzip1\n=====$report_gunzip2\n=====\n";
}else{
    print OUT "Step 0 :The file has been gunzipped!\n======\n=====\n";
}

my $report_trim1= `perl \$CLUSTER_SCRATCH/software/SolexaQA_1.12/DynamicTrim.pl $alias\_R1.fq`;
my $report_trim2= `perl \$CLUSTER_SCRATCH/software/SolexaQA_1.12/DynamicTrim.pl $alias\_R2.fq`;
print OUT "Step 1 :trim done!\n======\n$report_trim1\n$report_trim2\n=====\n";

my $report_len_srt = `perl \$CLUSTER_SCRATCH/software/SolexaQA_1.12/LengthSort.pl $alias\_R1.fq.trimmed $alias\_R2.fq.trimmed`;
`rm $alias\_R1.fq $alias\_R2.fq;rm $alias\_R1.fq.trimmed $alias\_R2.fq.trimmed`;
print OUT "Step 2 :Length sort done!\n======\n$report_len_srt\n=====\n";

if($bowtie eq "bowtie2"){
    my $report_bismark = `\$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark --$bowtie -p $proc_nu --$qual_type $index -1 $alias\_R1.fq.trimmed.paired1 -2 $alias\_R1.fq.trimmed.paired2`;
    print OUT "Step 3 :bismark mapping!\n======\n$report_bismark\n=====\n";
    print OUT "\$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark --$bowtie -p $proc_nu --$qual_type $index -1 $alias\_R1.fq.trimmed.paired1 -2 $alias\_R2.fq.trimmed.paired2\n\n";
    my $report_dedu = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/deduplicate_bismark -p $alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.bam`;
    print OUT "Step 4 :deduplication!\n======\n$report_dedu\n=====\n";
    print OUT "perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/deduplicate_bismark -p $alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.bam\n\n";
    my $report_methextra = `\$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark_methylation_extractor -p $alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.sam`;
    print OUT "Step 5 :methylation_extractor!\n======\n$report_methextra\n=====\n";
    print OUT "\$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark_methylation_extractor -p $alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.sam\n\n";

    my $report_gener_bed_CpG_OB = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CpG_OB_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CpG_OB_$alias.txt.gz`;
    my $report_gener_bed_CpG_OT = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CpG_OT_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CpG_OT_$alias.txt.gz`;
    my $report_gener_bed_CHG_OT = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CHG_OT_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CHG_OT_$alias.txt.gz`;
    my $report_gener_bed_CHG_OB = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CHG_OB_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CHG_OB_$alias.txt.gz`;
    my $report_gener_bed_CHH_OB = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CHH_OB_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CHH_OB_$alias.txt.gz`;
    my $report_gener_bed_CHH_OT = `perl \$CLUSTER_SCRATCH/software/bismark_v0.14.3/bismark2bed_xie.pl CHH_OT_$alias\_R1.fq.trimmed.paired1_bismark_bt2_pe.deduplicated.txt |gzip - > bed_CHH_OT_$alias.txt.gz`;
    print OUT "Generate bed files:
           $report_gener_bed_CpG_OB\n
           $report_gener_bed_CpG_OT\n
           $report_gener_bed_CHG_OT\n
           $report_gener_bed_CHH_OB\n
           $report_gener_bed_CHH_OT\n
	   \n"; 
}else{
}

sub usage{
    my $die=<<DIE;
    perl *.pl <reads1> <reads2> <process number> <quality type [phred33-quals] [phred64-quals]> <bowtie1 or 2> <geno_index> <-e [100 or]> <Alias> <report file> 
    one fastq file!
DIE
}
