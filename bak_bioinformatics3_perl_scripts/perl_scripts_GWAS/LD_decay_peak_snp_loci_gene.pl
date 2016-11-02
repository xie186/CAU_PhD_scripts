#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;

my ($ld_decay_reg, $gene_anno,$gene_pos) = @ARGV;

open ANNO,$gene_anno or die "$!";
my %gene_anno;
while(<ANNO>){
    chomp;
    my ($gene,$anno) = split(/\t/);
    $gene =~ s/FGP/FG/g;
    ($gene) = split(/_/,$gene) if $gene =~ /^GRM/;
    $anno = "--NA--" if $anno !~ /\w+/;
    $gene_anno{$gene} = $anno;
}

open POS,$gene_pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    $_ = "chr".$_ if $_ !~ /chr/;
    my ($chr,$stt,$end,$gene,$strand) = split;
    push @{$gene_pos{$chr}} , "$_";
}

open REG,$ld_decay_reg or die "$!";
my @tem_reg = <REG>;
my $tem_reg = join('', @tem_reg);
   @tem_reg = split(/###/,$tem_reg);
shift @tem_reg;
foreach my $tem_phe_reg(@tem_reg){ 
    my ($tem_phe,@tem_phe_reg)  = split(/region/,$tem_phe_reg);
    print "###$tem_phe";
    chomp $tem_phe;
    foreach $tem_reg (@tem_phe_reg){
        my ($one_region, @snp_infor) = split(/\n/,$tem_reg);
        my $snp_nu = @snp_infor;
        my ($chr,$stt,$end) = $one_region =~ /(chr\d+)\t(\d+)\t(\d+)/;
        my @region_gene = &judge($chr,$stt,$end, \@snp_infor);
        my $gene_nu = scalar @region_gene;
        print "##$tem_phe\tregion\t$chr\t$stt\t$end\t$snp_nu\t$gene_nu\n";
        foreach my $tem_gene (@region_gene){
            print "#$tem_phe\t$tem_gene";
        }
    }
}

sub judge{
    my ($chr,$stt,$end, $snp_infor_ref) = @_;
    my @region_gene;
    foreach my $tem_gene (@{$gene_pos{$chr}}){
        my ($chr1,$stt1,$end1,$gene1,$strand1) = split(/\t/,$tem_gene);
        if( ($stt1 <$stt && $end1 >=$stt ) || ($stt1 >= $stt && $stt1 <= $end) ){
            my ($dis) = &distance($chr1, $stt1, $end1, $gene1, $strand1, $snp_infor_ref);
            print "NA\t$gene1\n" if !exists $gene_anno{$gene1};
            push @region_gene, "$chr1\t$stt1\t$end1\t$gene1\t$strand1\t$dis\t$gene_anno{$gene1}\n";
#            print "$chr1\t$stt1\t$end1\t$gene1\t$strand1\t$dis\n";
        }
    }
    return @region_gene;
}

sub distance{
    my ($chr1, $stt1, $end1, $gene1, $strand1, $snp_infor_ref) = @_;
    my @dis;
    foreach my $peak_snp(@{$snp_infor_ref}){
        my ($chr,$peak_snp_pos) = split(/\t/, $peak_snp);
        my $minus_stt = $peak_snp_pos - $stt1;
        my $minus_end = $peak_snp_pos - $end1;
        if($minus_stt >0 && $minus_end >0){
            push @dis , $minus_end;
        }elsif($minus_stt < 0 && $minus_end < 0){
            push @dis , abs($minus_stt);
        }else{
            push @dis , 0;
        }
    }
    my ($dis) = sort {$a<=>$b} @dis;
    return $dis;
}

sub usage{
    my $die =<<DIE;
    perl *.pl  <LD decay region>  <gene annotation> <gene position>
DIE
}
