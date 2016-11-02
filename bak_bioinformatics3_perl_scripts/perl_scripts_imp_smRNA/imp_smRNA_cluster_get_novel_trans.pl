#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==2;
my ($trans,$trans_loc) = @ARGV;

open LOC,$trans_loc or die "$!";
my %hash_loc;
while(<LOC>){
     chomp;
     my ($locus,$pos,$tis1,$tis2,$tis3,$tis4) = split;
     next if $pos !~/chr\d+/;
     my ($chr,$strand,$stt,$end) = $pos =~/(chr\d+)\[(.*)\](\d+)-(\d+)/;   #  chr0[+]2569650-2569665
     $hash_loc{$locus} = "$chr\t$strand\t$stt\t$end";
}

open TRAN,$trans or die "$!";
while(<TRAN>){
    chomp;
    my ($con,$locus,$gene_id,$class_code,$tis1,$tis2,$tis3,$tis4) = split;
    next if ($class_code ne "i" && $class_code ne "u" && $class_code ne "e");  
    my $exp_nu = 0;
       $exp_nu ++ if $tis1 ne "-";
       $exp_nu ++ if $tis2 ne "-";
       $exp_nu ++ if $tis3 ne "-";
       $exp_nu ++ if $tis4 ne "-";
    print "$hash_loc{$locus}\t$locus\t$class_code\t$exp_nu\t$tis1,$tis2,$tis3,$tis4\n";
    
}

sub usage{
    print <<DIE;
    perl *.pl <cuffmerge tracking file> <cuffmerge loci> 
DIE
    exit 1;
}
