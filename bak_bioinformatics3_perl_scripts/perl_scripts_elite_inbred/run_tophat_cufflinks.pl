#!/usr/bin/perl -w
use strict;
my ($reads1,$reads2,$inner_size,$inner_sd,$tophat_v,$cufflink_v,$tophat_out_dir,$cuff_out_dir, $tophat_g, $lib) = @ARGV;
die usage() unless @ARGV == 10;

if($lib eq "SE"){
    my $tem1 = `/NAS1/software/tophat-$tophat_v.Linux_x86_64/tophat -g $tophat_g --bowtie1 -r  $inner_size --mate-std-dev $inner_sd -p 2 -o $tophat_out_dir /NAS1/data/bismark_index/bowtie_index/maize_pseudo_chr_bowwidx_xie $reads1,$reads2`;
    print "xxx\t $tem1\n";
}else{
    my $tem1 = `/NAS1/software/tophat-$tophat_v.Linux_x86_64/tophat -g $tophat_g --bowtie1 -r  $inner_size --mate-std-dev $inner_sd -p 2 -o $tophat_out_dir /NAS1/data/bismark_index/bowtie_index/maize_pseudo_chr_bowwidx_xie $reads1 $reads2`;
}
my $tem2 = system("/NAS1/software/cufflinks-$cufflink_v.Linux_x86_64/cufflinks -p 2 -o $cuff_out_dir -u -G /NAS1/data/blast/maize_5b_release/filtered-set/ZmB73_5b_FGS_chr_xie.gff $tophat_out_dir/accepted_hits.bam");
sub usage{
    print <<DIE;
    perl *.pl <reads1> <reads2> <inner_size_mean> <inner_size_sd> <tophat version> <cufflink version> <tophat output dir> <cufflink output dir> <tophat -g> <lib type>
DIE
    exit 1;
}
