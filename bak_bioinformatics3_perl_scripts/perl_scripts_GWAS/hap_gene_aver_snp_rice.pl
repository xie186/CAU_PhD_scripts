#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($ge_pos,$hapmap,$out) =@ARGV;

open SNP,$hapmap or die "$!";
open OUT,"+>$out" or die "$!";
my $head = <SNP>;
my ($tem_snp_id,$tem_geno,$tem_chr,$tem_pos,$tem_na1,$tem_na2,$tem_na3,$tem_na4,$tem_na5,$tem_na6,$tem_na7,@name) = split(/\s+/,$head);
my %snp_pos;
while(<SNP>){
    chomp;
    my ($snp_id,$geno,$chr,$pos,$na1,$na2,$na3,$na4,$na5,$na6,$na7,@geno) = split;
    $snp_pos{"$chr\t$pos"} ++;
}

open POS,$ge_pos or die "$!";
my %hash_snp_nu;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
    next if !/^\d/;
    $chr = "chr".$chr if $chr =~ /^\d/;
    for(my $i = $stt; $i<=$end; ++$i){
        $hash_snp_nu{$gene} ++;
    }
}

foreach(keys %hash_snp_nu){
    $hash_snp_nu{$_} = 0 if !exists $hash_snp_nu{$_};
    print OUT "$_\t$hash_snp_nu{$_}\n"
}

sub usage{
    my $die=<<DIE;
    print *.pl <Candidate gene pos> <Hapmap> <OUT>
DIE
}
