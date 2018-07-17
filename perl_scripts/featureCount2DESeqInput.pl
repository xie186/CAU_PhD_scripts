#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($feature, $tis) = @ARGV;

my $tis_header = $tis;
$tis_header=~s/,/\t/g;
print "gene_id\t$tis_header\n";
open FEA, $feature or die "$!";
while(<FEA>){
    chomp;
    next if (/#/ || /Geneid/);
    #Geneid	Chr	Start	End	Strand	Length
    my ($id, $chr,$stt,$end,$strand, $len, @count) = split;
    my $sum = 0;
    for(my $i = 0; $i < @count; ++$i){
        $sum += $count[$i];
    }
    next if $sum ==0;
    my $count = join("\t", @count);
    print "$id\t$count\n";
}
close FEA;

sub usage{
    my $die=<<DIE;
perl $0 <count> <tis>
DIE
}
