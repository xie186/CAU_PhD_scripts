#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($te_in,$rpkm)=@ARGV;

open IN,$te_in or die "$!";
my %hash;
while(<IN>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$te)=split;
    $hash{$gene}=$te;
}

open DUP,$rpkm or die "$!";
while(<DUP>){
    chomp;
#    my ($gene1,$sub1,$rpkm1,$gene2,$sub2,$rpkm2)=split;
    my ($id1,$id2,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    next if  (!exists $hash{$gene1} || !exists $hash{$gene2});
#    print "$_\t$hash{$gene1}\t$hash{$gene2}\n" if (exists $hash{$gene1} && exists $hash{$gene2});
    if($rpkm1 > $rpkm2){
        print "$gene1\t$rpkm1\t$gene2\t$rpkm2\t$hash{$gene1}\t$hash{$gene2}\n";
    }else{
        print "$gene2\t$rpkm2\t$gene1\t$rpkm1\t$hash{$gene2}\t$hash{$gene1}\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE or> <Dup RPKM>
DIE
}
