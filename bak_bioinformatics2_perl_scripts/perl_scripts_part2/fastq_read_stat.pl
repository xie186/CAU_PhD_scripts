#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($fq) = @ARGV;

my ($read_nu, $read_len,$read_base) = (0,0,0);
open FQ,$fq or die "$!";
my $i=0;
while(<FQ>){
    ++ $i;
    chomp;
    my $seq = <FQ>;
    chomp $seq;
    <FQ>;
    my $tem = <FQ>;
    ++ $read_nu;
    $read_len = length $seq;
    $read_base += $read_len;
}
print "$fq\t$read_nu\t$read_len\t$read_base\n";
sub usage{
    print <<DIE;
    perl *.pl <FASTQ> 
DIE
    exit 1; 
}
