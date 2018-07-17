#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 6;
sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <context> <OTOB> <cut depth> <OUT> 
DIE
}
my ($sam_list, $dir, $context, $OTOB, $cut, $out) = @ARGV;

open SAM, $sam_list or die "$!";
my $sam_num = 0;
my %rec_pos;
my %rec_tot;
while(my $sam = <SAM>){
    chomp $sam;
    ++$sam_num;
    open BED, "zcat $dir/bed_$context\_$OTOB\_$sam.txt.gz|" or die "$!";
    while(my $line = <BED>){
        chomp $line;
        #chr5    11702671        2       74      2.7027027027027
        my ($chr, $pos, $c_num, $depth, $lev) = split(/\t/, $line);
        $chr =~ s/chr//g;
        $rec_pos{"$chr $pos"} ++ if $depth >= $cut;
        $rec_tot{$sam} ++ if $depth >= $cut;
    }
    close BED;
}
close SAM;

open OUT, "+>$out" or die "$!";
my $stat_num = 0;
foreach(keys %rec_pos){
    if($rec_pos{$_} == $sam_num){
        $_=~s/ /\t/g;
        print OUT "$_\n";
        ++$stat_num;
    }
}

my $tot_num = keys %rec_pos;
my @sam = keys %rec_tot;
my @sam_tot = values %rec_tot;
my $sam = join("\t", @sam);
my $sam_tot = join("\t", @sam_tot);
print "geno\tTotal_sites(1)\tTot(All)\t$sam\n";
print "$out\t$tot_num\t$stat_num\t$sam_tot\n";

