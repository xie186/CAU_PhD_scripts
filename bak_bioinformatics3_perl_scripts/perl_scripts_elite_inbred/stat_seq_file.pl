#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($file, $lib, $out) = @ARGV;
my @file = split(/,/, $file);
my @lib = split(/,/, $lib);

open OUT, "+>$out" or die "$!";
for(my $i = 0; $i < @file; ++$i){
    my $read = $file[$i];
    ## get md5sum 
    my ($md5_val, $modi_time) = &file_stat($file[$i]);
    if($read =~ /\.gz/){
        if($read =~ /\.tar\.gz/){
            $read = "tar -xOf $read|";
        }else{
            $read = "zcat $read|";
        }
    }

    open READ,$read or die "$!";
    my $length = 0;
    my $tot_base = 0;
    my $read_nu = 0;
    while(<READ>){
        chomp;
        <READ>;
        <READ>;
        my $seq = <READ>;
        chomp $seq;
        $length = length $seq;
        $tot_base += length $seq;
        ++$read_nu;
    }
    print OUT "$file[$i]\t$md5_val\t$modi_time\t$lib[$i]\t$length\t$read_nu\t$tot_base\n";
}
close OUT;

sub file_stat{
    my ($tem_file) = @_;
    my $md5sum = `md5sum $tem_file`;
    my ($md5_val) = split(/\s+/, $md5sum);
    my $file_report = `file $tem_file`; 
    my $modi_time = "NA";
    ($modi_time) = $file_report=~/last modified:(.*)/ if $file_report=~/last modified:/;
    return ($md5_val, $modi_time);
}
sub usage{
    print <<DIE;
    perl *.pl <Reads> <read library [PE]> <OUT>
DIE
    exit 1;
}
