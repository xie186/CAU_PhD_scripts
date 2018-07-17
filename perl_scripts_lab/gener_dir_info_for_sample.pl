#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($file, $prefix) = @ARGV;
open FILE, $file or die "$!";
my $header = <FILE>;
chomp $header;
my @header=split(/\t/, $header);
print "$header\tDir\n";
while(<FILE>){
    chomp;
    next if /^#/;
    my %tem_infor = &extract_infor($_);
    my ($label, $date) = ($tem_infor{"#Accession"}, $tem_infor{"Date"});
    my @dir = <$prefix/$date/*$label*/>;
    my $dir = join(",", @dir);
    print "$_\t$dir\n";
}

sub extract_infor{
    my ($line) = @_;
    my @line = split(/\t/, $line);
    my %tem_hash;
    for(my $i=0; $i < @line; ++$i){
        $line[$i] =~ s/\s+/-/g;
        $tem_hash{$header[$i]} = $line[$i];
    }
    return %tem_hash;
}

sub usage{
my $die =<<DIE;
perl *.pl <File List> <dir prefix>
DIE
}

