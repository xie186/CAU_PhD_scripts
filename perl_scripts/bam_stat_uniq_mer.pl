#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($file) = @ARGV;
open FILE, $file or die "$!";
my %rec_map_tot;
my %rec_map_mapped;
my %rec_date;
while(<FILE>){
    next if /^#/;
    chomp;
    my ($acc, $date, $sample_name, $tot_reads, $mapped_reads, $map_eff, $proper_pair, $proper_pair_eff) = split;
    $rec_map_tot{"$acc\t$sample_name"} +=$tot_reads;
    $rec_map_mapped{"$acc\t$sample_name"} +=$mapped_reads;
    $rec_date{"$acc\t$sample_name"} .= "$date;";
}

foreach my $acc_sam(keys %rec_map_tot){
    print "$acc_sam\t$rec_map_tot{$acc_sam}\t$rec_map_mapped{$acc_sam}\t$rec_date{$acc_sam}\n";
}

sub usage{
my $die =<<DIE;
perl *.pl <File List>
DIE
}
