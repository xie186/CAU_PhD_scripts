#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($module, $rpkm, $out) = @ARGV;
open MOD,$module or die "$!";
<MOD>;
my %hash_clus;
my %hash_clus_name;
while(<MOD>){
    chomp;
    $_ =~ s/"//g;
    my ($gene_num, $clus_num) = split(/,/,$_);
    $hash_clus{$gene_num} = $clus_num;
    $hash_clus_name{$clus_num} ++;
}
close MOD;

print "$module: done\n";
my @clus = sort{$a<=>$b} keys %hash_clus_name;

open RPKM,$rpkm or die "$!";
<RPKM>;
my $num = 1;
my %gene_clus;
while(<RPKM>){
    my ($gene) = split;
    for(my $i = 0; $i < @clus; ++$i){
        if($hash_clus{$num} == $clus[$i]){
            push @{$gene_clus{$gene}}, "2";
        }else{
            push @{$gene_clus{$gene}}, "0";
        }
    }
    ++$num;
}
close RPKM;
print "$rpkm: done\n";

open OUT, "+>$out" or die "$!";
my $header = join("\tclus", ("gene_id", @clus));
print OUT "$header\n";
foreach my $gene (keys %gene_clus){
    my $tem_print = join("\t",@{$gene_clus{$gene}});
    print OUT "$gene\t$tem_print\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <module> <rpkm> <out>
DIE
}
