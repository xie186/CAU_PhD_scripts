#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($ld_block,$gene,$gene_anno,$gene_nu_cut) = @ARGV;
open GENE,$gene or die "$!";
my %hash_gene;
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    push @{$hash_gene{"chr$chr"}}, $_;
}

open ANNO,$gene_anno or die "$!";
<ANNO>;
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene) = split(/\t/);
    $gene_anno{$gene} = $_;
}

open BLK,$ld_block or die "$!";
my ($pheno,$r2_cut) = $ld_block =~ /GAPIT.(.*).photype.ld_block.(.*).res/;
while(<BLK>){
    chomp;
    $_ =~ s/\tchr\d+\_\d+//g;
    my ($group,$blk,$chr,$stt,$end,$snp_nu,@snp) = split;
    my @gene;
    foreach my $gene (@{$hash_gene{$chr}}){
        my ($tem_chr,$tem_stt,$tem_end,$tem_gene,$tem_strand) = split(/\t/,$gene);
        my ($in_or) = &judge($tem_stt,$tem_end,$stt,$end);
        if($in_or eq "yes"){
            print "xxx$tem_gene\n" if !exists $gene_anno{$tem_gene};
            push @gene, $gene_anno{$tem_gene};
            
        }
    }
    my $gene_nu = scalar @gene;
    ## pheno r2_cut 
    my $len = $end - $stt +1;
    my $genes = join("\t",@gene) if $gene_nu > 0;
       $genes = "no_gene" if $gene_nu == 0;
    print "$pheno\t$chr\t$stt\t$end\t@snp\t$gene_nu\t$genes\n" if  $gene_nu <= $gene_nu_cut;
}

sub judge{
    my ($stt1,$end1,$stt2,$end2) = @_;
    if($stt1 <=$end2 && $end1 >= $stt2){
        my $return = "yes";
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <LD block> <gene position> <gene annotation> <gene number cutoff>
DIE
}
