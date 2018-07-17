#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($phylip, $datatype) = @ARGV;
sub usage{
    my $die =<<DIE;
perl $0 <phylip> <datatype> 
DIE
}
open PHY, $phylip or die "$!";
my $header = <PHY>;
my ($num, $num_base) = split(/\s+/, $header);

my @aln = <PHY>;
my $aln = join("", @aln);

print <<OUT;
#NEXUS
begin data;
dimensions ntax=$num nchar=$num_base;
format datatype=$datatype interleave=no gap=-;
matrix
$aln
;
end;
OUT
