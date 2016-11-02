#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($ld,$snp_map) = @ARGV;

open MAP,$snp_map or die "$!";
my %hash_map;
my $snp_pos_rela = 0;
my $chrom = "";
while(<MAP>){
    chomp;
    my ($chr,$snp_pos,$snp_pos_abs) = split;
        $chrom = $chr;
    $hash_map{$snp_pos_rela + 1} = $snp_pos_abs;
    ++$snp_pos_rela;
}

open LD,"$ld" or die "$!";
my @total = <LD>;
my $total = join("",@total);
   @total = split(/Multiallelic/,$total);
my $i=1;
foreach my $block(@total){ 
    chomp $block;
    my @line = split(/\n/,$block);
    my $hap_nu = @line - 1;
    if($block =~ /Dprime/){
        $hap_nu -=1;
    }
    my ($snp_nu, $tag_snp_nu, $block_size) = (0, 0, 0);
    my ($stt,$end) = (0,0);
    foreach my $line(@line){
        next if $line !~/BLOCK/;
        $tag_snp_nu = $line =~s/!//g;
        my ($tem_bk,$tem_bk_nu,$marker,@marker) = split(/\s+/,$line);
        $snp_nu = @marker;
	$stt =$marker[0];
	$end =$marker[-1];
        $block_size = $hash_map{$end} - $hash_map{$stt} +1;
    }
    $tag_snp_nu = 1 if $tag_snp_nu == 0;
#     print "$block" if $tag_snp_nu == 0;
    print "chr$chrom\t$hash_map{$stt}\t$hash_map{$end}\tblock$i\t$hap_nu\t$snp_nu\t$tag_snp_nu\t$block_size\n";
    ++$i;
}

sub usage{
    print <<DIE;
    perl *.pl <GERBIL block> <SNP map>    >> Out
    <Chrom> <stt> <end> <Block ID> <block_nu> <haplotype_nu> <snp_nu> <tag_snp_nu>	<block_size>
DIE
    exit 1;
}
