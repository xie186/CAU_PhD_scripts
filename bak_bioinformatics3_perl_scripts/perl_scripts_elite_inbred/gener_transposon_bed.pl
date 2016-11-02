#!/usr/bin/perl
die usage() if @ARGV == 0;
open NEW,"$ARGV[0]" or die;
while(<NEW>){
	chomp;
	my @array = split /\s+/;
	if($array[0] =~ /\d+/){
		print "chr$array[0]\t$array[3]\t$array[4]\ttransposon\n";
	}
}
close NEW;
sub usage{
	my $die =<<DIE;
	usage:perl *.pl transposon_gff
DIE
}
