#!/usr/bin/perl -w

use strict;
die "Usage:perl *.pl <TRANSCRIPTS><SNP>" unless @ARGV==2;
open TRA,$ARGV[0] or die "$!";
open SNP,$ARGV[1] or die "$!";

#my @snp=<SNP>;
my @trs=<TRA>;
my $sp;
#     while($trans=<TRA>){
while($sp=<SNP>){
         my $trans;
         foreach $trans(@trs){
         chomp $sp;
         chomp $trans;
         my ($snp_chr,$snp_pos)=(split(/\s+/,$sp))[0,1];
         my ($tra_chr,$tra_pos1,$tra_pos2,$depth)=(split(/\s+/,$trans))[0,1,2,3];
         if($snp_chr ne $tra_chr){
#             print "I\'m here\n";
             next;
         }elsif($snp_pos>=$tra_pos1 && $snp_pos<=$tra_pos2){
             print "$sp\t$tra_pos1\t$tra_pos2\n";
             last;
         }else{
            next;
         }
         }
}

close SNP;
close TRA;
