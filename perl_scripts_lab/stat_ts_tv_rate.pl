#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($file, $var_dir, $pile_dir, $algo) = @ARGV;

open OUT, "+>number_of_sites_covered_each_cmp.txt" or die "$!" if -e "number_of_sites_covered_each_cmp.txt";
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
print "Ctrl\tSubculture\tsample_type\tAT->GC\tGC->AT\tAT->CG\tAT->TA\tGC->TA\tGC->CG\tATnum\tGCnum\tNormal_Ti/Tv\n";
while(<FILE>){
    next if /^#/;
    my ($control, $stress, $sample, $day) = split;
    my %stat_num = (
    "AT->GC" => 0,
    "GC->AT" => 0,
    "AT->CG" => 0,
    "AT->TA" => 0,
    "GC->TA" => 0,
    "GC->CG" => 0
    );
    my %stat_sites = (
    "AT" => 0,
    "GC" => 0,
    );
    open TEM, "$var_dir/VarScan_$stress\_$control.snp.Somatic.hc.fil.pass" or die "$!";
    while(my $line = <TEM>){
         chomp $line;
         my ($chr,$pos,$ref,$alt) = split(/\t/, $line);
         my $type = $hash_file{"$ref"."$alt"};
         $stat_num{$type} ++;
    }
    close TEM;
    open PILE, "$pile_dir/VarScan_$stress\_$control.pileup" or die "$!";
    while(my $line = <PILE>){
        chomp $line;
        #chr1    17      C       8       .......^].      JFGJIDF@        11      ........,..     JJIJJG@+IFC
        my ($chr, $pos, $ref, $dep1, $base1, $qual1, $dep2, $base2, $qual2) = split(/\t/, $line);
        next if ($dep1 < 8 || $dep2 < 8);
        if($ref eq "A" || $ref eq "T"){
            $stat_sites{"AT"} ++;
        }else{
            $stat_sites{"GC"} ++;
        }
    }
    if($algo eq "PERG"){
        my $AT_GC = $stat_num{"AT->GC"}/$stat_sites{"AT"};
        my $GC_AT = $stat_num{"GC->AT"}/$stat_sites{"GC"};
        my $AT_CG = $stat_num{"AT->CG"}/$stat_sites{"AT"};
        my $AT_TA = $stat_num{"AT->TA"}/$stat_sites{"AT"};
        my $GC_TA = $stat_num{"GC->TA"}/$stat_sites{"GC"};
        my $GC_CG = $stat_num{"GC->CG"}/$stat_sites{"GC"};
        my $ratio_ti_tv = ($AT_GC + $GC_AT)/($AT_CG + $AT_TA + $GC_TA + $GC_CG);
        #print qq($control\t$stress\t$sample\t$stat_num{"AT->GC"}\t$stat_num{"GC->AT"}\t$stat_num{"AT->CG"}\t$stat_num{"AT->TA"}\t$stat_num{"GC->TA"}\t$stat_num{"GC->CG"}\n);
        print qq($control\t$stress\t$sample\t$AT_GC\t$GC_AT\t$AT_CG\t$AT_TA\t$GC_TA\t$GC_CG\t$stat_sites{"AT"}\t$stat_sites{"GC"}\t$ratio_ti_tv\n);
    }elsif($algo eq "PERDG"){
        my $AT_GC = $stat_num{"AT->GC"}/$stat_sites{"AT"}/$day;
        my $GC_AT = $stat_num{"GC->AT"}/$stat_sites{"GC"}/$day;
        my $AT_CG = $stat_num{"AT->CG"}/$stat_sites{"AT"}/$day;
        my $AT_TA = $stat_num{"AT->TA"}/$stat_sites{"AT"}/$day;
        my $GC_TA = $stat_num{"GC->TA"}/$stat_sites{"GC"}/$day;
        my $GC_CG = $stat_num{"GC->CG"}/$stat_sites{"GC"}/$day;
        my $ratio_ti_tv = ($AT_GC + $GC_AT)/($AT_CG + $AT_TA + $GC_TA + $GC_CG);
        print qq($control\t$stress\t$sample\t$AT_GC\t$GC_AT\t$AT_CG\t$AT_TA\t$GC_TA\t$GC_CG\t$stat_sites{"AT"}\t$stat_sites{"GC"}\t$ratio_ti_tv\n);
    } 
    my $tot = $stat_sites{"AT"} + $stat_sites{"GC"};
    print OUT qq($control\t$stress\t$sample\t$day\t$stat_sites{"AT"}\t$stat_sites{"GC"}\t$tot\n);
    
}

sub usage{
    my $die =<<DIE;
    perl *.pl <file> <variation dir> <pileup dir> <PERD(Per Gerneration Per Day)|PERG(Per Gerneration)>
DIE
}
