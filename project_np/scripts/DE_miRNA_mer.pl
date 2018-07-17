#!/usr/bin/perl -w
use strict;

my ($deg, $sam_pair) = @ARGV;

my @deg = split(/,/, $deg);
my @sam_pair =  split(/,/, $sam_pair);
my @header;
my %rec_miRNA;
for(my $i = 0; $i < @deg; ++$i){
    open DE, $deg[$i] or die "$!";
    while(my $line = <DE>){
        chomp $line;
        next if $line =~ /^id/;
        #id      baseMean        baseMeanA       baseMeanB       foldChange      log2FoldChange  pval    padj
        my ($num, $id, $baseMean, $baseMeanA, $baseMeanB, $foldChange, $log2FoldChange, $pval, $padj) = split(/\t/, $line);
        $rec_miRNA{$id} -> {$sam_pair[$i]} = "$baseMeanA\t$baseMeanB\t$log2FoldChange";
    }
    close DE;
    push @header, "$sam_pair[$i]:baseMeanA\t$sam_pair[$i]:baseMeanB\t$sam_pair[$i]:log2FoldChange";
}

my $header = join("\t", @header);
print "id\t$header\n";
foreach my $id (keys %rec_miRNA){
    my @exp_info;
    foreach my $sam(@sam_pair){
        if(!exists $rec_miRNA{$id} -> {$sam}){
	    $rec_miRNA{$id} -> {$sam} = "NA\tNA\tNA";
        }
	push @exp_info, $rec_miRNA{$id} -> {$sam};
    }
    my $exp_info = join("\t", @exp_info);    
    print "$id\t$exp_info\n";
}

