#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($read, $lib ,$out) = @ARGV;

$read = "zcat $read|" if $read =~ /\.gz$/;
open READ,$read or die "$!";
my $length = 0;       # total bases
my $read_nu = 0;      # read number 
my $read_len = 0;     # read length
while(<READ>){
    chomp;
    my $seq = <READ>;
    <READ>;
    <READ>;
    chomp $seq;
    $length += length $seq;
    $read_len = length $seq;
    ++$read_nu;
}

if($lib eq "PE"){
    $length = $length * 2;
    $read_nu = $read_nu * 2;
}
open OUT, "+>$out" or die "$!";
print OUT <<OUT;
reads_numer\tread_len\treads_bases
$read_nu\t$read_len\t$length
OUT


sub usage{
    print <<DIE;
    perl *.pl <Reads> <read library [PE]> <OUT>
DIE
    exit 1;
}
