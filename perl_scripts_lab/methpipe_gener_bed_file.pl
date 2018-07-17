#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($bed, $cut, $context) = @ARGV;
my @bed = split(/,/, $bed);
foreach(@bed){
    chomp;
    open BED, "zcat $_ |" or die "$!";
    my $strand = "+";
    if($_ =~ /$context\_OB/){
        $strand = "-";
    }
    while(my $line = <BED>){
        chomp $line;
        #chr1    10000149        1       27      3.7037037037037
        my ($chr,$pos1, $c_num, $dep) = split(/\t/, $line);
        next if $dep < $cut;
        #print "$chr,$pos1, $c_num, $dep\n";
        my $lev = $c_num/$dep;
        
        #chr5    743     +       CpG     0.827586        29
        print "$chr\t$pos1\t$strand\t$context\t$lev\t$dep\n";        
    }
    close BED;
}

sub usage{
    my $die =<<DIE;
perl *.pl <bed [bed1, bed2]> <cutoff>  <context>
DIE
}
