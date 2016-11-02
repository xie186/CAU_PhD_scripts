#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($snp_infor,$cluster) = @ARGV;
open INFO,$snp_infor or die "$!";
my %hash;
while(<INFO>){
    chomp;
    my ($chr,$pos,$alle1,$alle2,$alle3,$alle4) = split;
    push @{$hash{"$chr\t$pos"}},($alle1,$alle2,$alle3,$alle4);
}

open CLUST,$cluster or die "$!";
while(<CLUST>){
    chomp;
    my ($chr,$stt,$end) = split;
    my ($alle1,$alle2,$alle3,$alle4,$nu) = (0,0,0,0,0);
    for(my $i = $stt-1; $i<=$end-1; ++$i){
        if(exists $hash{"$chr\t$i"}){
            ++$nu;
            ($alle1,$alle2,$alle3,$alle4) = ($alle1+${$hash{"$chr\t$i"}}[0],$alle2+${$hash{"$chr\t$i"}}[1],$alle3+${$hash{"$chr\t$i"}}[2],$alle4+${$hash{"$chr\t$i"}}[3]);
        }
    }
    print "$_\t$nu\t$alle1\t$alle2\t$alle3\t$alle4\n";
}
sub usage{
    my $die=<<DIE;
    perl *.pl <SNP> <Cluster>
    We use this scripts to get snp
DIE
}
