#!/usr/bin/perl -w
die usage() unless @ARGV == 2;
open F,$ARGV[0] or die;
while(<F>){
	my @tem=split;
	$hash{$tem[0]}{$tem[1]}++;
}
close F;
open G,$ARGV[1] or die;
while(<G>){
	@tem=split;
	print if $hash{$tem[2]}{$tem[3]};
}
close G;

sub usage{
    my $die = <<DIE;
    perl *.pl <bed> <hapmap> 
DIE
}
