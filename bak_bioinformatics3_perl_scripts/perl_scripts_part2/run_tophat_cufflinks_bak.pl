#!/usr/bin/perl -w
use strict;
my ($tophat_out_dir,$cuff_out_dir,$reads1,$reads2,$report) = @ARGV;
die usage() unless @ARGV == 5;
open OUT,"+>$report" or die "$!";
my $tem = 10;
my $tem = system("/home/bioinformatics/software/tophat-2.0.0.Linux_x86_64/tophat -p 3 -o $tophat_out_dir /home/bioinformatics/data/pseudochromosome/chrv2/maize_pseudo2.fasta $reads1,$reads2");
#print OUT "$tem\n";
   $tem = system("/home/bioinformatics/software/cufflinks-2.0.0.Linux_x86_64/cufflinks -p 3 -o $cuff_out_dir -u -F 0 -g /home/bioinformatics/data/blast/maize_5b_release/filtered-set/ZmB73_5b_FGS_chr_xie.gff -G /home/bioinformatics/data/blast/maize_5b_release/filtered-set/ZmB73_5b_FGS_chr_xie.gff --compatible-hits-norm $tophat_out_dir/accepted_hits.bam");
print OUT "$tem\n";
sub usage{
    print <<DIE;
    perl *.pl  <tophat out dir> <cuff_out_dir> <reads1> <reads2>
DIE
    exit 1;
}
