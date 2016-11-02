#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($snp, $clus) = @ARGV;
open SNP,$snp or die "$!";
my %snp_pos;
while(<SNP>){
    chomp;
    my ($chr,$pos ) = split;
    $snp_pos{"$chr\t$pos"} ++;
}

open CLUS,$clus or die "$!";
while(<CLUS>){
    chomp;
    my ($chr,$stt,$end) = split;
    for(my $i = $stt;$i <= $end;++$i){
        print "$chr\t$i\n" if exists $snp_pos{"$chr\t$i"};
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <SNP> <Clus>
DIE
}
