===============NOT done ===============================
#!/usr/bin/perl -w
use strict;

my ($snp_pos,$geno_len,$chrom) = @ARGV;
my $BIN = 5000000;

open SNP,$snp_pos or die "$!";
my %diver;
while(<SNP>){
    chomp;
    my ($chr,$pos) = split;
    $diver{"$chr\t$pos"} ++;
}

open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    $geno_len{$chr} = $len;
}

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

