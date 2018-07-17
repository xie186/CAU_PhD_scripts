#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($read, $lib ,$out) = @ARGV;

if($read =~ /\.gz/){
    if($read =~ /\.tar\.gz/){
        $read = "tar -xOf $read|";
    }else{
        $read = "zcat $read|";
    }
}
open READ,$read or die "$!";
my $length = 0;
my $read_nu = 0;
my %read_len;
while(<READ>){
    chomp;
    <READ>;
    <READ>;
    my $seq = <READ>;
    chomp $seq;
    $length += length $seq;
    my $tem_len = length $seq;
    $read_len{$tem_len} ++;
    ++$read_nu;
}

if($lib eq "PE"){
    $length = $length * 2;
    $read_nu = $read_nu * 2;
}

my $read_len = join("/", keys %read_len);
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
