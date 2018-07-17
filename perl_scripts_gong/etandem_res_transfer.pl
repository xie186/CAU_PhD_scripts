#!/usr/bin/perl -w
use strict;

my ($etandem, $chr) = @ARGV;

my @etandem = split(/,/, $etandem);
my @chr = split(/,/, $chr);

my $count = 0;
for(my $i = 0; $i < @etandem; ++$i){
    open TAN,$etandem[$i] or die "$!";
    while(my $line = <TAN>){
       $line =~ s/^\s+//;
       next if $line !~ /\+/;
       my ($stt, $end, $strand, $score,  $size, $count, $identity, $consensus) = split(/\s+/, $line);
       print "$chr[$i]\t$stt\t$end\tTandem_$count\t$strand\t$count\t$identity\t$consensus\n";
       ++$count;
    }
    
}
