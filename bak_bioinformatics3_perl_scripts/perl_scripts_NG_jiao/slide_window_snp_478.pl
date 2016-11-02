#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==3;
my ($snp,$win, $step) = @ARGV;
open T, "$snp" or die "$!";
my @snp=<T>;
my $n=@snp;

for(my $i=0; $i < $n; $i += $step){
    last if !$snp[$i + $win + $step] || $snp[$i + $win + $step]=~/^\s+$/;
    my $pp1=0;
    my $pp2=0;
    for(my $j=0; $j <= $win - 1; $j ++){
        my @fen = split(/\s+/,$snp[$i + $j]);
        my @ff5003 = split(/\:/,$fen[10]);
        my @ff478 = split/\:/,$fen[11];
        if($ff5003[0] eq $ff478[0]){
           $pp1++;
           print "$fen[1]\t";}
        else{
           $pp2++;
           print "$fen[1]\t";}

    }
    print "$pp1\t$pp2\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp> <win> <step> 
DIE
}
