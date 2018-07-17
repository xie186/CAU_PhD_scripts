#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($go) = @ARGV;

my %rec_go;
open GO, $go or die "$!";
while(<GO>){
    #AT1G01010       gene:2200934    AT1G01010.1     located in      nucleus GO:0005634
    my ($gene_id, $gene, $isoform, $state, $subcellular, $go) = split(/\t/);
    $rec_go{$gene_id}->{$go} ++;
}
close GO;

foreach(keys %rec_go){
    my @go = keys %{$rec_go{$_}};
    my $go_tem = join("\t", @go);
    $_=~s/\s/_/g;
    print "$_\t$go_tem\n";
}

sub usage{
    my $die =<<DIE;
perl *.pl <GO> 
DIE
}
