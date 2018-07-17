#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($file, $tis) = @ARGV;
my @file = split(/,/, $file);
my @tis = split(/,/, $tis);
print "#Accession\tTotalReads\tMappedReads\tMappingPercentage\tProperPair\tProperPairPercentage\n";
for(my $i =0; $i < @file; ++$i){
    my $tem_file = $file[$i];
    open TEM, "$tem_file" or die "$!";
    my @stat = <TEM>;
    my ($tot_reads) = $stat[0] =~ /(\d+) \+ 0 in total.*\n/;
    my ($mapped_reads, $map_eff) = $stat[2] =~ /(\d+) \+ 0 mapped \((.*)%\:-*nan%\)/;
    my ($proper_pair, $proper_pair_eff) = $stat[6] =~ /(\d+) \+ 0 properly paired \((.*)%\:-*nan%\)/;
    print "$tis[$i]\t$tot_reads\t$mapped_reads\t$map_eff\t$proper_pair\t$proper_pair_eff\n";

}

sub usage{
my $die =<<DIE;
perl *.pl <File List [stat1,stat2]> <Tis [Tis1, Tis2]>
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
