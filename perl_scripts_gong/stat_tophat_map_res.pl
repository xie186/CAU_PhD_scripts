#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($file, $sample) = @ARGV;
my @file = split(/,/, $file);
my @sample = split(/,/, $sample);

for(my $i =0; $i < @file; ++ $i){
    open IN,$file[$i] or die "$!";
    my @line = <IN>; 
       chomp @line;
    my $line = join("", @line);
       
    my ($l_in, $l_map, $l_per, $l_mul, $l_mul_per) = $line =~ /Left\s+reads:.*Input:\s*(\d+).*Mapped:\s+(\d+).*\((\d+\.\d%).*of\s+these:\s*(\d+).*\((\d+\.\d%).*Right/;
    my ($r_in, $r_map, $r_per, $r_mul, $r_mul_per) = $line =~ /Right\s+reads:.*Input:\s*(\d+).*Mapped:\s+(\d+).*\((\d+\.\d%).*of\s+these:\s*(\d+).*\((\d+\.\d%).*Aligned/;
    my ($align_pair, $align_mul, $align_mul_per) = $line =~ /Aligned pairs:\s+(\d+)\s+of these:\s+(\d+)\s+\((\d+\.\d%)\)/;
    #print "$l_in, $l_map, $l_per, $l_mul, $l_mul_per\n";
    #print "$r_in, $r_map, $r_per, $r_mul, $r_mul_per\n";
    #print "$align_pair, $align_mul, $align_mul_per\n";
    print "$sample[$i]\t$l_in\t$l_map\t$l_per\t$l_mul\t$l_mul_per\t$r_in\t$r_map\t$r_per\t$r_mul\t$r_mul_per\t$align_pair\t$align_mul\t$align_mul_per\n"; 
    

my $tem =<<SUMMARY;
Left reads:
               Input:  49845284
              Mapped:  47774035 (95.8% of input)
            of these:  23201996 (48.6%) have multiple alignments (5299 have >20)
Right reads:
               Input:  49845284
              Mapped:  47107621 (94.5% of input)
            of these:  22815895 (48.4%) have multiple alignments (5158 have >20)
95.2% overall read alignment rate.

Aligned pairs:  45534567
     of these:  20236418 (44.4%) have multiple alignments
          and:   1335408 ( 2.9%) are discordant alignments
88.7% concordant pair alignment rate.
SUMMARY
}
sub usage{
   my $die =<<DIE;
   perl *.pl <summary [sam1,sam2,sam3]> <sample_id [sam1,sam2]> 
DIE
}
