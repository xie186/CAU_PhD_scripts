#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 7;

my ($vcf,$geno_len,$chrom,$fgs,$alias,$inbred1,$inbred2) = @ARGV;
my $BIN = 500000;
open ALIAS,$alias or die "$!";
my ($tem_cau1,$tem_cau2);
while(<ALIAS>){
    chomp;
    my ($fam,$cau_acc,$real) = split;
    $tem_cau1 = $cau_acc if $real eq $inbred1;
    $tem_cau2 = $cau_acc if $real eq $inbred2;
}

open VCF,$vcf or die "$!";
my $head = <VCF>;
my ($dot1,$dot2,$dot3,@cau_acc) = split(/\t/,$head);
my ($index1,$index2);
for(my $i = 0;$i < @cau_acc;++$i){
    $index1 = $i if $cau_acc[$i] eq $tem_cau1;
    $index2 = $i if $cau_acc[$i] eq $tem_cau2;
}

open FGS,$fgs or die "$!";
my %gene_pos;
while(<FGS>){
   chomp;
   my ($chr,$tools,$ele,$stt,$end)  = split;
      $chr = "chr".$chr if $chr !~ /chr/;
   for(my $i = $stt; $i <= $end;++ $i){
       $gene_pos{"$chr\t$i"} ++;
   }
}
my %diver;
while(<VCF>){
    chomp;
    $_ =~ s/[A-Z]\/[A-Z]/x/g;
    my ($chr,$pos,$alle,@geno) = split;
    next if !exists $gene_pos{"$chr\t$pos"};
    my ($in_alle1,$in_alle2) = ($geno[$index1],$geno[$index2]);
    if ($in_alle1 ne "x" && $in_alle2 ne "x"){
        if($in_alle1 ne $in_alle2){
            $diver{"$chr\t$pos"} = 1;
        }else{
            $diver{"$chr\t$pos"} = 0;
        }
    }
}

open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    $geno_len{$chr} = $len;
}

#print "Done go\n";
for(my $i = 0; $i < $geno_len{$chrom}/$BIN;++$i){
    my ($tot,$diver) = (0,0);
    foreach my $coor(keys %diver){
        my ($chr,$pos) = split(/\t/,$coor);
        if($chr eq $chrom && $pos >= $i*$BIN && $pos < ($i+1)*$BIN){
            ++ $tot;
            if($diver{$coor} == 1){
                ++ $diver;
            }
        }
    }
    next if $tot == 0;
    my $perc_diver = $diver/$tot;
    my ($stt,$end) = ($i*$BIN, ($i+1)*$BIN);
    print "$stt\t$end\t$diver\t$tot\t$perc_diver\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <vcf> <geno_len> <chrom> <FGS gene> <alias> <inbred> <inbred2>
DIE
}
