#!/usr/bin/perl -w
use strict;

my ($geno_len,$gene_pos,$gene_anno,$region) = @ARGV;
die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
    perl *.pl <geno length> <gene position> <gene annotation> <region> 
DIE
}

open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    $geno_len{$chr} = $len;
}

open POS,$gene_pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    $chr = "chr".$chr if $chr !~/chr/;
    my $pos = int (($stt+$end)/2);
    $gene_pos{"$chr\t$pos"}  = $_;
}

open ANNO,$gene_anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,$anno) = split(/\t/);
    $gene_anno{$gene} = $anno;
}

open REG,$region or die "$!";
while(<REG>){
    chomp;
    #../LD_group_LD_decay_peak_snp/result_2011_peak_snp_ld_decay_reg_WGS.res:##KNPR  region  chr6    10038190        10047650
    my ($pheno,$dot,$chr,$stt,$end) = split;
    ($pheno) = $pheno =~ /##(.*)/;
    my @genes = &neast_gene($chr,$stt,$end);
    print "$pheno\t$dot\t$chr\t$stt\t$end\n";
    foreach my $tem_gene(@genes){
        my ($chr,$stt,$end,$gene,$strand) = split(/\t/,$tem_gene);
        print "$tem_gene\t$gene_anno{$gene}\n";
    }
}

sub neast_gene{
    my ($chr,$stt,$end) = @_;
    my @genes;
    my ($flag1,$flag2) = (0,0);
    for(my $i = $stt; $i > 0; --$i){
        if (exists $gene_pos{"$chr\t$i"}){
            unshift @genes,$gene_pos{"$chr\t$i"};
            ++$flag1;
        }
        last if $flag1 ==3;
    }
    
    for(my $i = $end; $i < $geno_len{$chr}; ++$i){
        if (exists $gene_pos{"$chr\t$i"}){
            push @genes,$gene_pos{"$chr\t$i"};
            ++$flag2;
        }
        last if $flag2 ==3;
    }
    return @genes;
}
