#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($file) = @ARGV;
open FILE, $file or die "$!";
while(<FILE>){
    next if /^#/;
    chomp;  
    my ($acc, $type, $geno,$generation, $stress, $date, $dir) = split;
    open TEM, "$type\_$geno\_$generation\_$stress\_$date\_srt.stat" or die "$!";
    my @stat = <TEM>;
    my ($tot_reads) = $stat[0] =~ /(\d+) \+ 0 in total.*\n/;
    my ($mapped_reads, $map_eff) = $stat[2] =~ /(\d+) \+ 0 mapped \((.*)%\:nan%\)/;
    my ($proper_pair, $proper_pair_eff) = $stat[6] =~ /(\d+) \+ 0 properly paired \((.*)%\:nan%\)/;
    print "$_\t$tot_reads\t$mapped_reads\t$map_eff\t$proper_pair\t$proper_pair_eff\n"; 
}

sub usage{
my $die =<<DIE;
perl *.pl <File List>
DIE
}

=Stat results
33594404 + 0 in total (QC-passed reads + QC-failed reads)
0 + 0 duplicates
21116071 + 0 mapped (62.86%:nan%)
33594404 + 0 paired in sequencing
16797202 + 0 read1
16797202 + 0 read2
20785362 + 0 properly paired (61.87%:nan%)
20949470 + 0 with itself and mate mapped
166601 + 0 singletons (0.50%:nan%)
44428 + 0 with mate mapped to a different chr
25620 + 0 with mate mapped to a different chr (mapQ>=5)
=cut
