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

open OUT,"+>$pep_out" or die "$!";
open PEAK,$peak or die "$!";
my @pheno = <PEAK>;
my $tem_join = join('',@pheno);
   @pheno = split(/####/,$tem_join);
   shift @pheno;
foreach(@pheno){
    my ($phe_name,@snp) = split(/\n/,$_);
    ($phe_name) = $phe_name =~ /GAPIT\.(.*)\.photype\.GWAS\.ps\.p2log/;
    $phe_name =~ s/_/-/g;
    foreach my $tem_snp(@snp){
        my ($chrom, $pos, $maf, $p_log,$peak_type) = split(/\t/,$tem_snp);
        next if $peak_type ne "max_peak";
        $chrom = "chr".$chrom;
        foreach my $gene(keys %hash_gene){
            my ($chr,$stt,$end,$strand)  = split(/\t/,$hash_gene{$gene});
            if($chrom eq $chr){
                next if ($stt > $pos + $windows/2 || $end < $pos - $windows/2);
                print "$phe_name\t$chr\t$pos\t$p_log\t$chr\t$stt\t$end\t$strand\t$gene\n";
                print OUT ">$chr\_$pos\_$p_log\_$phe_name\_$gene\n$hash_pep{$gene}\n";
            }
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <Peak SNPs> <gene position> <windows> <Peptide sequence> <Pep out> 
DIE
}
