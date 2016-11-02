#!/usr/bin/perl
use strict;
die usage() if @ARGV == 0;

my $annotation = $ARGV[0];
my $total;
my $transposon;
my $intergenic;
my $downstream;
my $upstream;
my $intro;
my $exon;
my %hash;

open NEW,"$annotation" or die;
while(<NEW>){
	chomp;
	my @array = split /\s+/;
	my $target = "$array[0]"."-"."$array[1]";
	$hash{$target}.="$array[6]\t";
}
close NEW;

foreach my $key(keys %hash){
	$total++;
	if($hash{$key} =~ /transposon/){
		$transposon++;
	}
	elsif($hash{$key} =~ /exon/){
		$exon++;
	}
	elsif($hash{$key} =~ /intron/){
		$intro++;
	}
	elsif($hash{$key} =~ /upstream/){
		$upstream++;
	}
	elsif($hash{$key} =~ /downstream/){
		$downstream++;
	}
	else{
		$intergenic++;
	}
}
my $result_intergenic=$intergenic/$total;
my $result_downstream=$downstream/$total;
my $result_upstream=$upstream/$total;
my $result_intro=$intro/$total;
my $result_exon=$exon/$total;
my $result_transposon=$transposon/$total;
print "Intergenic\t$intergenic\t$result_intergenic\nDownstream\t$downstream\t$result_downstream\nUpstream\t$upstream\t$result_upstream\nIntron\t$intro\t$result_intro\nExon\t$exon\t$result_exon\nTransposon\t$transposon\t$result_transposon\n";

sub usage{
	my $die =<<DIE;
	usage:perl *.pl annotation_file
DIE
}
