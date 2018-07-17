#!/usr/bin/perl
use strict;

die usage() if @ARGV == 0;

my ($OT,$OB) = @ARGV;

my %hash;

$OT = "zcat $OT|" if $OT =~ /gz$/;
$OB = "zcat $OB|" if $OB =~ /gz$/;
open NEW1,"$OT" or die;
while(<NEW1>){
	chomp;
	my @array = split /\s+/;
	my $position = "$array[0]\t$array[1]";
	my $number_C = int($array[3]*$array[4]/100+0.5);
	my $number_T = $array[3]-$number_C;
	push @{$hash{$position}},"$number_C\t$number_T";
}
close NEW1;

open NEW2,"$OB" or die;
while(<NEW2>){
	chomp;
	my $temp_position;
	my @array = split /\s+/;
	if($OB =~ /CpG/){
		$temp_position = $array[1]-1;
	}
	elsif($OB =~ /CHG/){
		$temp_position = $array[1]-2;
	}
	else{
		$temp_position = $array[1];
	}
	my $position = "$array[0]\t$temp_position";
	my $number_C = int($array[3]*$array[4]/100+0.5);
	my $number_T = $array[3]-$number_C;
	push @{$hash{$position}},"$number_C\t$number_T";
}
close NEW2;

print "chromosome\tposition\tnumber_of_C\tnumber_of_T\n";
foreach my $key(keys %hash){
	my $number = @{$hash{$key}};
	if($number == 1){
		print "$key\t$hash{$key}[0]\n";
	}
	elsif($number == 2){
		my @array1 = split /\s+/,$hash{$key}[0];
		my @array2 = split /\s+/,$hash{$key}[1];
		my $combined_C = $array1[0]+$array2[0];
		my $combined_T = $array1[1]+$array2[1];
		print "$key\t$combined_C\t$combined_T\n";
	}
}

sub usage{
	my $die = <<DIE;
	usage:perl *.pl bed_OT_file.gz bed_OB_file.gz >bed_OTOB_file
DIE
}
