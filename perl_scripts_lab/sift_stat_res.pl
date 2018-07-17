#!/usr/bin/perl -w
use strict;

my ($info, $sift_dir, $out) = @ARGV;
die usage() unless @ARGV ==3;
sub usage{
    my $die =<<DIE;
perl $0 <infor sift> <sift dir> <out>
DIE
}
my %rec_sift_res;
open INFO, $info or die "$!";
open OUT, "+>$out" or die "$!";
while(<INFO>){
    chomp;
    my ($chr, $geno_pos, $dot1, $ref, $alt, $amino_chg, $aa1, $pos, $aa2, $id) = split;
    next if !/^chr/;
    #AT5G66030.1.SIFTprediction
    my $sift_res = "$sift_dir/$id.SIFTprediction"; 
    next if exists $rec_sift_res{"$id\t$aa1$pos$aa2"};
    if(!-e $sift_res){
        print "grep '$id' info_for_SIFT_down.txt |grep 'down' > long_gene_cause_error.txt\n"; 
        #print "csh /scratch/conte/x/xie186/software/sift5.2.2/bin/SIFT_for_submitting_fasta_seq.csh ./protein_seq/$id.fasta /scratch/conte/x/xie186/software/sift5.2.2/db/uniref90.fasta ./protein_seq/$id.subst\n";
        next;
    }
    open TMP, $sift_res or die "$!";
    while(my $res = <TMP>){
        #S22N    TOLERATED       0.35    2.88    168     254
	#WARNING! H34 not allowed! score: 0.03 median: 2.93 # of sequence: 177
        next if $res =~ /WARNING/;
        my ($codon_chg, $class, $score, $median_info) = split(/\s+/, $res);
        $rec_sift_res{"$id\t$codon_chg"} = "$class\t$score";
    }
    close TMP;
    print OUT qq($_\t$rec_sift_res{"$id\t$aa1$pos$aa2"}\n);
}
close INFO;
close OUT;

=pod
Output	Description
SIFT Score	Ranges from 0 to 1. The amino acid substitution is predicted damaging is the score is <= 0.05, and tolerated if the score is > 0.05.
Median Info	Ranges from 0 to 4.32, ideally the number would be between 2.75 and 3.5. This is used to measure the diversity of the sequences used for prediction. A warning will occur if this is greater than 3.25 because this indicates that the prediction was based on closely related sequences.
=end
