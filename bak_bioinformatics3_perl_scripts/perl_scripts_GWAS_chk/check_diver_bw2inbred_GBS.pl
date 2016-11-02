#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;

my ($vcf,$geno_len,$chrom,$inbred1,$inbred2) = @ARGV;
my $BIN = 5000000;

open VCF,$vcf or die "$!";
my $head = <VCF>;
my ($dot1,$dot2,$dot3,@cau_acc) = split(/\t/,$head);
my ($index1,$index2);
for(my $i = 0;$i < @cau_acc;++$i){
    $index1 = $i if $cau_acc[$i] eq $inbred1;
    $index2 = $i if $cau_acc[$i] eq $inbred2;
}

print "xx\t$index1\t$index2\n";
my %diver;
while(<VCF>){
    chomp;
#    $_ =~ s/[A-Z]\/[A-Z]/x/g;
    my ($chr,$pos,$alle,@geno) = split;
    my ($in_alle1,$in_alle2) = ($geno[$index1],$geno[$index2]);
    if ($in_alle1 ne "N" && $in_alle2 ne "N"){
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
    perl *.pl <vcf> <geno_len> <chrom> <alias> <inbred> <inbred2>
DIE
}
