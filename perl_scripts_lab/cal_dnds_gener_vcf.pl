#!/usr/bin/perl -w
use strict;

my ($region, $fa) = @ARGV;
die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl $0 <region> <fasta> 
DIE
}
$/ = "\n>";
open FA, $fa or die "$!";
my %rec_genofa;
while(<FA>){
    chomp;
    $_ =~ s/>//g;
    my ($chr, $seq) = split(/\n/, $_, 2);
    $seq =~ s/\n//g;
    $rec_genofa{$chr} = $seq;
}

$/ ="\n";
open REGION, $region or die "$!";
while(<REGION>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt; $i <= $end; ++$i){
        my $ref = substr($rec_genofa{$chr}, $i -1 , 1);
        my $alt  = &gener_alt($ref);
        print "$chr\t$i\t.\t$ref\t$alt\t100\n";
    }
}

sub gener_alt{
    my ($ref) = @_;
    my $base = "ATGC";
    $base =~ s/$ref//g;
    my $rand = int(rand(3));
    return substr($base, $rand, 1);
}

