#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($file, $var_dir) = @ARGV;

open FILE, $file or die "$!";
my %hash_file = (
### Transition
"AG" => "AT->GC","TC" => "AT->GC",
"GA" => "GC->AT","CT" => "GC->AT",
#Tranversion
"AC" => "AT->CG","TG" => "AT->CG",
"AT" => "AT->TA","TA" => "AT->TA",
"GT" => "GC->TA", "CA" => "GC->TA",
"GC" => "GC->CG", "CG" => "GC->CG"
);
print "Ctrl\tSubculture\tsample_type\tAT->GC\tGC->AT\tAT->CG\tAT->TA\tGC->TA\tGC->CG\n";
while(<FILE>){
    next if /^#/;
    my ($control, $stress, $sample) = split;
    my %stat_num = (
    "AT->GC" => 0,
    "GC->AT" => 0,
    "AT->CG" => 0,
    "AT->TA" => 0,
    "GC->TA" => 0,
    "GC->CG" => 0
    );
    open TEM, "$var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass" or die "$!";
    while(my $line = <TEM>){
         chomp $line;
         my ($chr,$pos,$ref,$alt) = split(/\t/, $line);
         my $type = $hash_file{"$ref"."$alt"};
         $stat_num{$type} ++;
    }
    close TEM;
    print qq($control\t$stress\t$sample\t$stat_num{"AT->GC"}\t$stat_num{"GC->AT"}\t$stat_num{"AT->CG"}\t$stat_num{"AT->TA"}\t$stat_num{"GC->TA"}\t$stat_num{"GC->CG"}\n);
}

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <variation dir>
DIE
}
