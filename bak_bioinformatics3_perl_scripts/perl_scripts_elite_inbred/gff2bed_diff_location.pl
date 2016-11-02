#!/usr/bin/perl -w
use strict;

my ($gff) = @ARGV;
open GFF,$gff or die "$!";
#open OUT, "+>$out" or die "$!";
while(<GFF>){
    chomp;
    #chr9    ensembl exon    68562   68582  .       +       .
    my ($chr,$tool,$ele,$stt,$end,$dot,$strand) = split;
    my ($tem_stt,$tem_end) = (0, 0);
    if($ele eq "exon" || $ele eq "intron"){
        print "$chr\t$stt\t$end\t$ele\t$strand\n";
    }elsif($ele eq "gene"){
        if($strand eq "+"){
            my ($tem_stt,$tem_end) = ($stt - 2000, $stt - 1);
            $tem_stt = 0 if $tem_stt < 0;
            print "$chr\t$tem_stt\t$tem_end\tupstream\t$strand\n";
               ($tem_stt,$tem_end) = ($end + 1, $end + 2000);
            print "$chr\t$tem_stt\t$tem_end\tdownstream\t$strand\n";
        }else{
            my ($tem_stt,$tem_end) = ($stt - 2000, $stt - 1);
            $tem_stt = 0 if $tem_stt < 0;
            print "$chr\t$tem_stt\t$tem_end\tdownstream\t$strand\n";
               ($tem_stt,$tem_end) = ($end + 1, $end + 2000);
            print "$chr\t$tem_stt\t$tem_end\tupstream\t$strand\n";
        }
    }
}
