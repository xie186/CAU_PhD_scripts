#!/usr/bin/perl -w
use strict;
my ($reads1,$reads2,$inner_size,$inner_sd,$tophat_v,$cufflink_v,$tophat_out_dir,$cuff_out_dir) = @ARGV;
die usage() unless @ARGV == 8;
my $tem1 = `/NAS1/software/tophat-$tophat_v.Linux_x86_64/tophat --bowtie1 -r $inner_size --mate-std-dev $inner_sd -p 1 -o $tophat_out_dir /NAS1/data/bismark_index/bowtie_index/maize_pseudo_chr_bowwidx_xie $reads1,$reads2`;  ## modified by xie 20120903   $reads1,$reads2 <=> $reads1 $reads2
print OUT "xxx\t $tem1\n";
my   $tem2 = system("/NAS1/software/cufflinks-$cufflink_v.Linux_x86_64/cufflinks -p 1 -o $cuff_out_dir -u -F 0 -g /NAS1/data/blast/maize_5b_release/filtered-set/ZmB73_5b_FGS_chr_xie.gff $tophat_out_dir/accepted_hits.bam");
sub usage{
    print <<DIE;
    perl *.pl <reads1> <reads2> <inner_size_mean> <inner_size_sd> <tophat version> <cufflink version> <tophat output dir> <cufflink output dir>
DIE
    exit 1;
}
