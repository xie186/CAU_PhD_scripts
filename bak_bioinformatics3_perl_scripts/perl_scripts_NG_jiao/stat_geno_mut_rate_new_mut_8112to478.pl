#!/usr/bin/perl -w
open F,$ARGV[0] or die;
while(<F>){
	@tem=split;
        my ($gt58, $AF58 ,$dp58) = (split(/:/, $tem[-4]));
        my ($gt5003, $AF5003,$dp5003) = (split(/:/, $tem[-3]));
        my ($gt478, $AF478, $dp478) = (split(/:/, $tem[-2]));
        my ($gt8112, $AF8112, $dp8112) = (split(/:/, $tem[-1]));

#	print "$_\t$gt5003,$dp5003,$gt478,$dp478,$gt8112,$dp8112\n" if !$gt5003;
	if($dp8112>=5 && $dp5003>=5 && $dp478>=5 && $dp58>=5  && $gt478 ne $gt8112 && $gt478 eq $gt58){
		print "$_";#$tem[0]\t$tem[1]\t$tem[-3]\t$tem[-2]\n";
	}
}
close F;


