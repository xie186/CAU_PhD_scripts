#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <context> <OTOB> <list of ana sites>  
DIE
}
my ($sam_list, $dir, $context, $OTOB, $list) = @ARGV;

open LIST, $list or die "$!";
my %rec_list;
while(<LIST>){
    chomp;
    my ($chr,$pos) = split;
    $rec_list{"$chr $pos"} ++;
}

open SAM, $sam_list or die "$!";
my $sam_num = 0;
my %rec_pos;
my %rec_tot;
while(my $sam = <SAM>){
    chomp $sam;
    ++$sam_num;
    open BED, "zcat $dir/bed_$context\_$OTOB\_$sam.txt.gz|" or die "$!";
    open OUT, "|gzip - > bed_$context\_$OTOB\_$sam.txt.gz" or die "$!";
    while(my $line = <BED>){
        chomp $line;
        #chr5    11702671        2       74      2.7027027027027
        my ($chr, $pos, $c_num, $depth, $lev) = split(/\t/, $line);
        $chr =~ s/chr//g;
        if(exists $rec_list{"$chr $pos"}){
            print OUT "$line\n";
        }
    }
    close BED;
    close OUT;
}
close SAM;

