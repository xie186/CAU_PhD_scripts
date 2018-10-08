#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($dir,$inbred) = @ARGV;

open IN,$inbred or die "$!";
while(<IN>){
    chomp;
    my ($fam,$cau_acc,$inbred_name) = split;
    my $tem_acc = $cau_acc;
       $tem_acc =~ s/CAU0/CAU/;
    if( !-e "$dir/$tem_acc.sorted.picard.bam" && !-e "$dir/$cau_acc.sorted.picard.bam"){
        print "$cau_acc\n";
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <directory> <inbred lines> 
DIE
}
