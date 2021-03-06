#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 6;
my ($geno_len, $windows, $step, $sam1, $sam2, $out)=@ARGV;

open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    next if $chr !~ /\d/;
    $hash{$chr}=$len;
}

my %meth_alle1;
my @sam1 = split(/,/, $sam1);
foreach my $bed (@sam1){
    open ALLE1,"zcat $bed|" or die "$!";
    while(<ALLE1>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        @{$meth_alle1{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE1;
}

my %meth_alle2;
my @sam2 = split(/,/, $sam2);
foreach my $bed(@sam2){
    open ALLE2,"zcat $bed|" or die "$!";
    while(<ALLE2>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        @{$meth_alle2{"$chr\t$pos1"}}=($depth,$lev);
    }
    close ALLE2;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(sort keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/$step-1;++$i){
        my ($stt,$end)=(($i-1)*$step+1,($i-1)*$step+$windows);
        my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=&get($chrom,$stt,$end);
        next if ($c_cover_alle1 < 4 || $c_cover_alle2 < 4);
        print OUT "$chrom\t$stt\t$end\t$c_cover_alle1\t$c_nu_alle1\t$t_nu_alle1\t$c_cover_alle2\t$c_nu_alle2\t$t_nu_alle2\n";
    }
}

sub get{
    my ($chrom,$stt,$end)=@_;
    my ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2)=(0,0,0,0,0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $meth_alle1{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle1{"$chrom\t$i"}});
            $c_nu_alle1 += $c_nu;
            $t_nu_alle1 += $t_nu;
            ++ $c_cover_alle1;
        }
        if(exists $meth_alle2{"$chrom\t$i"}){
            my ($c_nu, $t_nu) = &cal_CT(@{$meth_alle2{"$chrom\t$i"}});
            $c_nu_alle2 += $c_nu;
            $t_nu_alle2 += $t_nu;
            ++ $c_cover_alle2;
        }
    }
    return ($c_cover_alle1,$c_nu_alle1,$t_nu_alle1,$c_cover_alle2,$c_nu_alle2,$t_nu_alle2);
}

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Windows size> <Step size> <sample1 [bed1,bed2]> <sample2 [bed1, bed2]> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> {allele1 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>} {allele2 <# of Cs covered by reads> <# of Cs sequenced in window> <# of Ts>}

DIE
}
