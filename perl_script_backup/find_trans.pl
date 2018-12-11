#!/usr/bin/perl -w
use strict;
use warnings;


open F,$ARGV[0] or die;
my $namebk=0;
my $stbk=0;
my $edbk=0;

while(<F>){
	my @tem=split;
	my $stbk=$tem[1];
	my $dep=$tem[3];
	my $chrbk=$tem[0];
#	my $dep=$tem[3];
	while(<F>){
		my @tem1=split;
		if($tem1[0] ne $chrbk){
			print "$tem[0]\t$tem[1]\t$stbk\t$dep\n";
			last;
		}
		if($tem1[1]-$stbk>100){
			print "$tem[0]\t$tem[1]\t$stbk\t$dep\n";
			last;
		}
		else{
			$chrbk=$tem1[0];
			$stbk=$tem1[1];
			$dep+=$tem1[3];

		}
	}
	
	redo if $_;
	last;	
}
