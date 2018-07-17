#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($file, $base_type, $var_dir, $pile_dir) = @ARGV;

open BASE, $base_type or die "$!";
my %rec_basetype;
while(<BASE>){
     chomp;
     next if (/^chrC/ || /^chrM/);
     my ($chr, $pos, $type) = split;
     $rec_basetype{"$chr\t$pos"} = $type;
}

$| = 1;
open FILE, $file or die "$!";
print "Ctrl\tSubculture\tMut_4-fold\tMut_Non_syn\tCov_4-fold\tCov_Non-syn\n";
while(<FILE>){
    next if /^#/;
    my ($control, $stress, $sample, $day) = split;
    open TEM, "$var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass" or die "$!";
    my %rec_type_num = (
    "4-fold"=> 0,
    "Non-syn" => 0
    );
    while(my $line = <TEM>){
         chomp $line;
         my ($chr,$pos,$ref,$alt) = split(/\t/, $line);
         if(exists $rec_basetype{"$chr\t$pos"}){
             $rec_type_num{$rec_basetype{"$chr\t$pos"}} ++;
         }
    }
    close TEM;
    
    my %rec_cov_num;
    open PILE, "$pile_dir/VarScan_$stress\_$control.pileup" or die "$!";
    while(my $line = <PILE>){
        chomp $line;
        #chr1    17      C       8       .......^].      JFGJIDF@        11      ........,..     JJIJJG@+IFC
        next if ($line =~ /^chrC/ || $line =~ /^chrM/);
        my ($chr, $pos, $ref, $dep1, $base1, $qual1, $dep2, $base2, $qual2) = split(/\t/, $line);
        next if ($dep1 < 8 || $dep2 < 8);
        if(exists $rec_basetype{"$chr\t$pos"}){
            $rec_cov_num{$rec_basetype{"$chr\t$pos"}} ++;
        }
    }
    print qq($_\t$rec_type_num{"4-fold"}\t$rec_type_num{"Non-syn"}\t$rec_cov_num{"4-fold"}\t$rec_cov_num{"Non-syn"}\n); 
}

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <base_type> <variation dir> <pileup dir>
DIE
}
