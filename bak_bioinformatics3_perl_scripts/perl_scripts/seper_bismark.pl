#!/usr/bin/perl -w
use strict;
my ($read)=@ARGV;
die usage() if @ARGV==0;

my $line=0;
open READ,$read or die "$!";
while(<READ>){
    $line++;
}

$line=(int ($line/4/5+1))*4;
system qq(split -l $line $read);

my @aa=<x*>;
system qq(nohup bismark /home/bioinformatics2/data/bismark_index/ $aa[0],$aa[1],$aa[2],$aa[3],$aa[4] --solexa1.3-quals --path_to_bowtie ~/software/bowtie-0.12.7/ -n 2 -l 28 -e 100 --chunkmbs 512 --directional --un $read.ump.fq --ambiguous $read.amb.fq > bis_$read.nohup 2>&1 &);

#system qq(rm $read);
print "@aa Doing!!!\n";

system qq(rm $aa[0] $aa[1] $aa[2] $aa[3] $aa[4]);


sub usage{
    my $die=<<DIE;
    perl *.pl <Read_trimmed INT> 
DIE
}
