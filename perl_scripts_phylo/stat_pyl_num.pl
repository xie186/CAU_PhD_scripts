#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;

sub usage{
    my $die = <<DIE;
pelr $0 <sample list> <fasta>
DIE
}
my ($sam_list, $in, $tree) = @ARGV;

open SAM, $sam_list or die "$!";
my %rec_acc; 
while(<SAM>){
    chomp;
    my ($acc, $clade, $fam, $species) = split(/,/, $_);
    $clade =~ s/\s+/_/g;
    $rec_acc{$acc} = "$acc\t$clade\t$fam\t$species";
}
close SAM;

open IN, $in or die "$!";
my %stat_num;
while(<IN>){
    chomp;
    if(/^>/){
         $_ =~ s/>//g;
         my ($acc) = split(/-/, $_);
         $stat_num{$acc} ++;
    }
}

foreach my $acc(keys %rec_acc){
    $stat_num{$acc} = 0 if !exists $stat_num{$acc};
    print "$rec_acc{$acc}\t$stat_num{$acc}\n";
}
