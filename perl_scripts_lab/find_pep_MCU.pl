#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
sub usage{
    my $die =<<DIE;
perl $0 <PEP> <list> 
DIE
}
my ($pep, $list) = @ARGV;

open LIST, $list or die "$!";
my %rec_mcu;
while(<LIST>){
    chomp;
    my ($mcu, $id) = split;
    $rec_mcu{$id} = $mcu;
}

$/ = "\n>";
open PEP, $pep or die "$!";
while(<PEP>){
    chomp;
    $_=~ s/>//g;
    #>AT1G51370.2 | Symbols:  | F-box/RNI-like/FBD-like domains-containing protein | chr1:19045615-19046748 FORWARD LENGTH=346
    my ($id, $seq) = split(/\n/, $_, 2);
    my ($trans_id) = split(/\s+/, $id);
    my ($gene_id) = split(/\./, $trans_id);
    print ">$trans_id-$rec_mcu{$gene_id}\n$seq\n" if exists $rec_mcu{$gene_id};
    
}
$/ = "\n";
