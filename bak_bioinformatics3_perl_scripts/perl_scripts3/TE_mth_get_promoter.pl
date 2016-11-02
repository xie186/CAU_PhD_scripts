#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($mth_TE,$gff) = @ARGV;

my %hash_mid;
open MTH,$mth_TE or die "$!";
while(<MTH>){
    chomp;
    my ($chr,$stt,$end,$strand,$type) = split;
    my $mid = int( ($stt+$end)/2);
    $hash_mid{"$chr\t$mid"} = $_;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    next if /^#/;
    my ($chr,$tools,$ele,$stt,$end) = split;
    next if $ele ne "upstream";
    for(my $i= $stt;$i <= $end ;++$i){
         print "$hash_mid{\"$chr\t$i\"}\n" if exists $hash_mid{"$chr\t$i"};
    }
   
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE meth> <GFF FGS>
DIE
}
