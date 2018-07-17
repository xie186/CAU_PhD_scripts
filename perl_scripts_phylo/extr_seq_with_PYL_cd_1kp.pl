#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($seq, $cd_search, $out) = @ARGV;
sub usage{
    my $die =<<DIE;
perl $0 <seq> <cd_search> <out>
DIE
}

my @rec_seq;
$/ = "\n>";
open SEQ, $seq or die "$!";
while(<SEQ>){
    $_ =~ s/>//g;
    $_ =~ s/\n$//g;
    push @rec_seq, $_;
}
$/ = "\n";

open CD, $cd_search or die "$!";
my %rec_seq;
while(<CD>){
    chomp;
    next if !/^Q#/;
    #Query   Hit type        PSSM-ID From    To      E-Value Bitscore        Accession       Short name      Incomplete      Superfamily
    my ($query, $hit_type, $pssm_id, $stt, $end, $evalue, $bitscore, $acc, $short_name) = split(/\t/);
    my ($num) = $query =~ /Q#(\d+)/;
    $num = $num -1;
    if($hit_type eq "specific"){
        if($short_name eq "PYR_PYL_RCAR_like"){
            $rec_seq{$rec_seq[$num]} ++;
        }else{
            print "$_\n";
        }
    }
}

open OUT, "+>$out" or die "$!";
foreach(keys %rec_seq){
    print OUT ">$_\n";
}
close OUT;
