#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==5;
my ($peak,$gene_pos,$windows,$pep,$pep_out) = @ARGV;
open POS,$gene_pos or die "$!";
my %hash_gene;
while(<POS>){
     chomp;
     my ($chr,$stt,$end,$gene,$strand) = split;
     $chr = "chr".$chr if $chr !~ /^chr/;
     $hash_gene{"$gene"} = "$chr\t$stt\t$end\t$strand";
     
}

my %hash_pep;
open PEP,$pep or die "$!";
my @pep =  <PEP>;
my $tem_seq = join('',@pep);
   @pep = split(/>/,$tem_seq);
shift @pep;
foreach(@pep){
    my ($name,@seq) = split(/\n/);
    my $seq = join('',@seq);
       ($name)  = $name =~ /parent_gene=(.*)/;
       $hash_pep{$name} = $seq;
}
open PEAK,$peak or die "$!";
open OUT,"+>$pep_out" or die "$!";
while(<PEAK>){
    chomp;
    next if /^##/;
    my ($pheno,$chrom,$pos,$p_value) = split(/\t/);
    $pheno =~ s/\s+/-/g;
    $chrom = "chr".$chrom;
    foreach my $gene(keys %hash_gene){
        my ($chr,$stt,$end,$strand)  = split(/\t/,$hash_gene{$gene});
        if($chrom eq $chr){
            next if ($stt > $pos + $windows/2 || $end < $pos - $windows/2); 
            print "$pheno\t$chr\t$pos\t$p_value\t$chr\t$stt\t$end\t$strand\t$gene\n";
            print OUT ">$chr\_$pos\_$p_value\_$pheno\_$gene\n$hash_pep{$gene}\n";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <Peak SNPs> <gene position> <windows> <FGS pep longest> <OUT pep>
DIE
}
