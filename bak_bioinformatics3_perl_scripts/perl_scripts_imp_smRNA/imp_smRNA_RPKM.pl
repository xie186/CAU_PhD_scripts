#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($clus,$pileup) = @ARGV;
open PILE,$pileup or die "$!";
my %hash_nu;
my $tot_read = 0;
while(<PILE>){
    chomp;
    my ($chr,$pos,$ref_base,$depth,$seq)  = split;
    my $nu = $seq =~ s/\^/M/g;
    if($nu){
        $hash_nu{"$chr\t$pos"} = $nu; 
        $tot_read += $nu;
    }
}

open CLUS,$clus or die "$!";
foreach(<CLUS>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $nu = 0;
    for(my $i = $stt;$i <= $end;++$i){
        $nu += $hash_nu{"$chr\t$i"} if exists $hash_nu{"$chr\t$i"};
    }
    my $rpkm = $nu*1000000*1000/(($end-$stt+1)*$tot_read);
    print "$_\t$rpkm\n";
}

sub usage{
    print <<DIE;
    perl *.pl <cluster> <pileup> 
DIE
   exit 1;
}
