#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1; 
my ($file) = @ARGV;
my @file = split(/,/, $file);
my %hash_pos;
my %hash_stat;
for(my $i = 0; $i< @file; ++$i){
    open FILE, $file[$i] or die "$!";
    while(my $line = <FILE>){
        chomp $line;
        my ($chr, $pos, $id, $ref, $alt, $qual, $filter) = split(/\t/, $line);
        $hash_pos{"$chr\t$pos"} = "$chr\t$pos\t$id\t$ref\t$alt\t$qual\t$filter";
        $hash_stat{"$chr\t$pos"} ++;
    }       
}

foreach(keys %hash_stat){
    print "$hash_pos{$_}\n" if $hash_stat{$_} ==3;;
}

sub usage{
    my $die =<<DIE;
    perl *.pl <File [file1,file2]>
DIE
}
