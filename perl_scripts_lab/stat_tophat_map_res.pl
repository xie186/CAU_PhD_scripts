#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($file, $sample, $lib) = @ARGV;
my @file = split(/,/, $file);
my @sample = split(/,/, $sample);

if($lib eq "SE"){
    print "#sample\t#OfReads\t#OfMappedReads\tPercentage\t#OfMultipleMappedReads\tPercentage\n";
}else{
    print "#sample\t#OfReads\t#OfMappedReads\tPercentage\t#OfMultipleMappedReads\tPercentage\n";
}
for(my $i =0; $i < @file; ++ $i){
    open IN,"./$file[$i]/align_summary.txt" or die "$!";
    my @line = <IN>; 
    close IN;
       chomp @line;
    my $line = join("", @line);
    if($lib eq "PE"){
        my ($l_in, $l_map, $l_per, $l_mul, $l_mul_per) = $line =~ /Left\s+reads:.*Input\s+:\s*(\d+).*Mapped\s*:\s+(\d+).*\(\s*(\d+\.\d%).*of\s+these:\s*(\d+).*\((\s*\d+\.\d%).*Right/;
        #print "$l_in, $l_map, $l_per, $l_mul, $l_mul_per\n";
        my ($r_in, $r_map, $r_per, $r_mul, $r_mul_per) = $line =~ /Right\s+reads:.*Input\s*:\s*(\d+).*Mapped\s*:\s+(\d+).*\(\s*(\d+\.\d%).*of\s+these:\s*(\d+).*\((\s*\d+\.\d%).*Aligned/;
        my ($align_pair, $align_mul, $align_mul_per) = $line =~ /Aligned pairs:\s+(\d+)\s+of these:\s+(\d+)\s+\((\d+\.\d%)\)/;
        my $in = $l_in + $r_in;
        print "$l_in + $r_in\n";
        my $map = $l_map + $r_map;
        my $per = $map/$in;
        my $mul = $l_mul + $r_mul;
        my $mul_per = $mul/$map;
        print "$sample[$i]\t$in\t$map\t$per\t$mul\t$mul_per\n";
    }elsif($lib eq "SE"){
        #my ($in, $map, $per, $mul, $mul_per) = $line =~ /Reads:.*Input:\s*(\d+).*Mapped:\s+(\d+).*\((\d+\.\d%).*of\s+these:\s*(\d+).*\((\d+\.\d%).*/;
        my ($in, $map, $per, $mul, $mul_per) = $line =~ /Reads:.*Input\s+:\s*(\d+).*Mapped\s+:\s+(\d+).*\((\d+\.\d%).*of\s+these:\s*(\d+).*\((\s*\d+\.\d%).*/;
        print "$sample[$i]\t$in\t$map\t$per\t$mul\t$mul_per\n";
    }
    
sub usage{
   my $die =<<DIE;
   perl *.pl <summary [sam1,sam2,sam3]> <sample_id [sam1,sam2]> <lib type>
DIE
}


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
$tem =<<SUMMARY;
Reads:
          Input     :   9333407
           Mapped   :   8524373 (91.3% of input)
            of these:   1084407 (12.7%) have multiple alignments (76 have >20)
91.3% overall read mapping rate.
SUMMARY
}

