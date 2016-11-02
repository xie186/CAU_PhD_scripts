#!/usr/bin/perl -w
die(" <window> <5003 bed> <8112 bed> <chr> <rate>\n") unless @ARGV==5;
my $rate=$ARGV[4];
my $chr=$ARGV[3];
open F,$ARGV[0] or die;
open G5003,"+>$ARGV[1]" or die;
open G8112,"+>$ARGV[2]" or die;
while(<F>){
	my @tem=split;
	my $gt5003=$tem[-2];
	my $gt8112=$tem[-1];
	if($gt5003/($gt5003+$gt8112)>=$rate){
		print G5003 "$chr\t$tem[0]\t$tem[-3]\t$gt5003\t$gt8112\n";
	}
	elsif($gt8112/($gt5003+$gt8112)>=$rate){
		print G8112 "$chr\t$tem[0]\t$tem[-3]\t$gt5003\t$gt8112\n";
	}
}
close F;
close G5003;
close G8112;
