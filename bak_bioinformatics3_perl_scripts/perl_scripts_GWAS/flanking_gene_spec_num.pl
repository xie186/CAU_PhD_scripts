#!/usr/bin/perl -w
use strict;
my ($anno,$gene,$region) = @ARGV;
die usage() unless @ARGV ==3;
open ANNO,$anno or die "$!";
my %anno;
while(<ANNO>){
    chomp;
    my ($gene,$annotation) = split(/\t/);
       $gene =~ s/FGP/FG/;
    ($gene) = split(/_/,$gene) if $gene =~ /GRMZM/;
    $anno{$gene} = $annotation;
}
open GENE,$gene or die "$!";
my %hash_gene;
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$tem_gene,$strand) = split;
        $chr = "chr".$chr if $chr !~ /chr/;
    push @{$hash_gene{$chr}} ,"$chr\t$stt\t$end\t$tem_gene\t$strand";
}

open REG,$region or die "$!";
while(<REG>){
    chomp;
    my ($chr,$stt,$end) = split;
    my %tem_hash_left;
    my %tem_hash_right;
    my %hash_strand;
    foreach my $line(@{$hash_gene{$chr}}){
        my ($chr1,$stt1,$end1,$tem_gene1,$strand1) = split(/\t/,$line);
        if($end1 < $stt){
            my $dis = $stt - $stt1 + 1;
            $tem_hash_left{"$tem_gene1"} = $dis;
            $hash_strand{"$tem_gene1"} = $strand1;
        }elsif($stt1 > $end){
            my $dis = $stt1 - $end + 1;
            $tem_hash_right{"$tem_gene1"} = $dis;
            $hash_strand{"$tem_gene1"} = $strand1;
        }else{
            my $dis = 0;
        }
    }
    my ($gene1,$gene2,$gene3) = (0,0,0);
       ($gene1,$gene2,$gene3) = sort{$tem_hash_left{$a}<=> $tem_hash_left{$b}} keys %tem_hash_left;
    print "$_\t$gene1\t$hash_strand{$gene1}\t$anno{$gene1}\n";
    print "$_\t$gene2\t$hash_strand{$gene2}\t$anno{$gene2}\n";
    print "$_\t$gene3\t$hash_strand{$gene3}\t$anno{$gene3}\n";
       ($gene1,$gene2,$gene3) = (0,0,0);
       ($gene1,$gene2,$gene3) = sort{$tem_hash_right{$a}<=> $tem_hash_right{$b}} keys %tem_hash_right;
    print "$_\t$gene1\t$hash_strand{$gene1}\t$anno{$gene1}\n";
    print "$_\t$gene2\t$hash_strand{$gene2}\t$anno{$gene2}\n";
    print "$_\t$gene3\t$hash_strand{$gene3}\t$anno{$gene3}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <annotation> <Gene> <region>
DIE
}
