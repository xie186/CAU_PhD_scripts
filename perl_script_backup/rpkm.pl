#!/usr/bin/perl -w
die("usage:perl rpkm.pl <pileup> <number of total reads> <cdna length> \n") unless @ARGV==3;
my $total=$ARGV[1];

my %length;
open LEN,$ARGV[2] or die;
while(<LEN>){
        $length{(split)[0]}=(split)[1];
}

open PILE,$ARGV[0] or die;
while(<PILE>){
	my @tem=split;
	my $depth+=$tem[3];
	while(<PILE>){
		my @tem1=split;
		last if $tem1[0] ne $tem[0];
		$depth+=$tem1[3];
	}
	
	my $ff=$length{$tem[0]};
	my $numread=$depth/100;
	my $rpkm=$numread*1000000000/($total*$ff);
	print "$tem[0]\t$ff\t",int $numread,"\t$rpkm\n";

	redo if $_;

}
