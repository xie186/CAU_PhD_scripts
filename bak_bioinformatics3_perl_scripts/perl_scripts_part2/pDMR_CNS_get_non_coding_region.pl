#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($region,  $input_dir) = @ARGV;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <input dir>
DIE
}

open REGION,$region or die "$!";
while(<REGION>){
    chomp;
    my ($dmr,$chr2, $stt2, $end2, $strand2, $chr1, $stt1, $end1, $strand1) = split;
    if(-e "./$input_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.txt"){   ## open the VISTA results 
        open RES,"./$input_dir/$chr2\_$stt2\_$end2\_$chr1\_$stt1\_$end1.txt" or die "$!";
        while (my $line = <RES>){
           #2364    (1390)  to     2476    (1501)  =      113bp  at  99.1%  noncoding 
           next if $line !~ /noncoding/;
           my ($tem_stt1,$tem_stt2,$tem_end1,$tem_end2) = $line =~ /(\d+)\s+\((\d+)\)\s+to\s+(\d+)\s+\((\d+)\)/;
              ($tem_stt1, $tem_end1) = ($stt2 + $tem_stt1 - 1, $stt2 + $tem_end1 - 1);
               
           print "$chr2\t$tem_stt1\t$tem_end1\n";
        }
    }else{
        next;
    }
}
