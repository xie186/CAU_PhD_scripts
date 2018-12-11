#!/usr/bin/perl -w
use strict;

#my ($score)=@ARGV;
#open F,$file or die;
while(<STDIN>){
	my $n1=$_;
	$_=<STDIN>;
	my $s=$_;
	$_=<STDIN>;
	my $n2=$_;
	$_=<STDIN>;
	my $q=$_;
	
	my @tem=split //,$q;
	my $sum;

	foreach my $aq(@tem){
		$sum+=(ord($aq)-64);
	}
#	print $sum,"\n";
	if($sum>=1800){
		print $n1,$s,$n2,$q;
	}
	
}
