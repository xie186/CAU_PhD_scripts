#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($clus) = @ARGV;
open CLUS,$clus or die "$!";
my $tot_reads;
my %hash_clus;
while(<CLUS>){
    chomp;
    my ($chr,$stt,$end,$reads) = split;
    #chr10   593478  593606  t0007334174_24_1;t0007858987_24_1;t0006187272_24_1 
    my @reads = split(/;/, $reads);
    my $read_nu = 0;
    foreach  my $read(@reads){
        my ($id,$len,$num) = split(/_/, $read); 
        $read_nu += $num;
        $tot_reads += $num;
    }
    $hash_clus{"$chr\t$stt\t$end"} = $read_nu;
}

foreach (keys %hash_clus){
    my ($chr, $stt,$end)  = split(/\t/,$_);
    my $len = $end - $stt + 1;
    my $rpkm = ($hash_clus{$_} * (10**6)) / ($tot_reads * $len);
    print "$chr\t$stt\t$end\t$chr\_$stt\_$end\t$rpkm\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <clus> 
DIE
}
