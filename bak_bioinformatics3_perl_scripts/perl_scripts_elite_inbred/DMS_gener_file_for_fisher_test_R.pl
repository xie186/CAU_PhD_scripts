#!/usr/bin/perl
use strict;

die usage() unless @ARGV == 2;

my ($parental_bed_file,$descendant_bed_file) = @ARGV;

my %hash;

open NEW1,"$parental_bed_file" or die;
while(<NEW1>){
	chomp;
        next if /chromosome/;
	my @array = split /\s+/;
	my $position = "$array[0]"."-"."$array[1]";
	my $methy_level= $array[2]/($array[2]+$array[3]);
	push @{$hash{$position}},"$_\t$methy_level";
}
close NEW1;

open NEW2,"$descendant_bed_file" or die;
while(<NEW2>){
	chomp;
        next if /chromosome/;
	my @array = split /\s+/;
	my $position = "$array[0]"."-"."$array[1]";
	my $methy_level = $array[2]/($array[2]+$array[3]);
	push @{$hash{$position}},"$_\t$methy_level";
}
close NEW2;

foreach my $key(keys %hash){
	my $number = @{$hash{$key}};
	next if $number ==1;
	my @array1 = split /-/,$key;
	my @array2 = split /\s+/,$hash{$key}[0];
	my @array3 = split /\s+/,$hash{$key}[1];
	my $discrepancy = $array2[-1]-$array3[-1];
	my $depth1=$array2[2]+$array2[3];
	my $depth2=$array3[2]+$array3[3];
	if($depth1>=5 and $depth2>=5){
		print "$array1[0]\t$array1[1]\t$array1[1]\t$array2[2]\t$array2[3]\t$array3[2]\t$array3[3]\t$array2[-1]\t$array3[-1]\t$discrepancy\n";
	}
}

sub usage{
	my $die = <<DIE;
	usage:perl *.pl bed_graph_file_1 bed_graph_file_2 >combined_file_for_Fisher_exact_text
DIE
}
