#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($sam1, $sam2, $out)=@ARGV;

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

open OUT,"+>$out" or die "$!";
my @sam2 = split(/,/, $sam2);
foreach my $bed(@sam2){
    open ALLE2,"zcat $bed|" or die "$!";
    while(<ALLE2>){
        chomp;
        my ($chr,$pos1,$pos2,$depth,$lev)=split;
        next if ($depth < 4 || $depth > 100);
        next if !exists $meth_alle1{"$chr\t$pos1"};
        my ($c_nu1, $t_nu1) = &cal_CT(@{$meth_alle1{"$chr\t$pos1"}}); 
        my ($c_nu2, $t_nu2) = &cal_CT($depth, $lev);
        print OUT "$chr\t$pos1\t$pos1\t1\t$c_nu1\t$t_nu1\t1\t$c_nu2\t$t_nu2\n";
    }
    close ALLE2;
}
close OUT;

sub cal_CT{
    my ($depth,$lev) = @_;
    my ($c_nu,$t_nu) = (int($depth*$lev/100+0.5) , $depth - (int($depth*$lev/100+0.5)));
#    print "$depth,$lev \t $c_nu, $t_nu \n";
    return ($c_nu, $t_nu);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <sample1 [bed1,bed2]> <sample2 [bed1, bed2]> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> {allele1 <# of Cs covered by reads> <# of Cs sequenced> <# of Ts>} {allele2 <# of Cs covered by reads> <# of Cs sequenced> <# of Ts>}

DIE
}
