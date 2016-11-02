#!/usr/bin/perl -w
open F,$ARGV[0] or die;
while(<F>){
	my @tem=split;
	$tem[3]-=1;
	/ID=(\S+)/;
	$hash{"chr$tem[0] $tem[3] $tem[4]"}=$1;
}
close F;

open G,$ARGV[1] or die;
while(<G>){
	chomp;
	my @tem=split;
	my $gene=$hash{"$tem[0] $tem[1] $tem[2]"};
	die("no gene $_\n") if !$gene;
	print "$_\t$gene\n";
}
close G;

