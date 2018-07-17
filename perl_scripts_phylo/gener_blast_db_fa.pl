#!/usr/bin/perl -w
use strict;

my ($sam_list, $dir, $out_prefix) = @ARGV;

die usage() unless @ARGV ==3;
sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <out prefix>
DIE
}
open OUTPROT, "+>$out_prefix.prots.fa" or die "$!";
#open OUTDNA, "+>$out_prefix.dnas.fa" or die "$!";
open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    #1kP_Sample,Clade,Family,Species,Tissue Type,Status,Voucher Data,Sample Provider,RNA Extractor
    my ($sam) = split(/,/, $_);
    if(-e "$dir/$sam-SOAPdenovo-Trans-assembly.prots_uniID.out"){
         open IN, "$dir/$sam-SOAPdenovo-Trans-assembly.prots_uniID.out" or die "$!";
         while(my $line = <IN>){
             my $seq = <IN>;
             chomp $seq;
             next if length $seq == 0;
             print OUTPROT "$line"."$seq\n";
         }
         close IN;
    }else{
        print "No prot seq: $_\n";
    } 
}
close SAM;
close OUTPROT;
