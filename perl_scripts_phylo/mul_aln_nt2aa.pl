#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
sub usage{
    my $die =<<DIE;
perl *.pl <aln results> <fasta cds> <Output> 
DIE
}
my ($aln, $fa, $out) = @ARGV;

$/ = "\n>";
open FA, $fa or die "$!";
my %rec_cds;
while(<FA>){
    chomp;
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    ($id) = split(/\s+/, $id);
    $seq =~ s/\n//g;
    $rec_cds{$id} = $seq;
}

open OUT, "+>$out" or die "$!";
open ALN, $aln or die "$!";
while(<ALN>){
    chomp;
    $_ =~ s/>//g;
    my ($id, $seq) = split(/\n/, $_, 2);
    print OUT ">$id\n";
    ($id) = split(/\s+/, $id);
    ($id) = split(/\(/, $id);
    if($_=~ /Zea_mays/){
        $id =~ s/\_P/_T/g;
        $id =~ s/\_FGP/_FGT/g;
    }
    $seq =~ s/\n//g;
    my @seq = split(//, $seq);
    my $index = 0;
    my $cds_seq = $rec_cds{$id};
    print "$id\n" if !exists $rec_cds{$id};
    my $out_seq;
    foreach my $base(@seq){
        if($base ne "-"){
            my $codon = substr($cds_seq, $index*3, 3);
            $out_seq .=$codon;
            $index ++;
        }else{
            $out_seq .="---";
        }
    }
    print OUT "$out_seq\n";
}
close OUT;
close FA;
