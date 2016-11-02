#!/usr/bin/perl -w
use strict;
my $win=$ARGV[1];
# slide window
my $nsite=0;
my $W=0;
my $st;
my $ed;
my $chr;
open F,$ARGV[0] or die;
while(<F>){
	while(<F>){
		next if /\-/;
		$nsite++;
		$st=(split)[3] if $nsite==1;
		$chr=(split)[2];
		my ($ref)=(split)[1]=~/(\w)\//;
		$ed=(split)[3];
		$W+=Wdenom($ref,$_);
		
		if($nsite==$win){
			print "$chr\t$st\t$ed\t",$ed-$st,"\t$W\t",$W/($ed-$st),"\n";
			$nsite=0;
			$W=0;
		}
	}
}
#count denom of each site

sub Wdenom{
	my $ref=shift @_;
	my $line=shift @_;
	my @arr=split /\s+/,$line;
	my $nref=0;
	my $nalt=0;
	my $nsam=0;
	for(my $x=11;$x<@arr;$x++){
		if($arr[$x]=~/N/){
			next;
		}
		elsif($arr[$x]=~/$ref/){
			$nref++;
		}
		else{
			$nalt++;
		}
	}
	$nsam=$nref+$nalt;
	my $homo=($nref*($nref-1)+$nalt*($nalt-1))/($nsam*($nsam-1));
	my $pi=1-$homo;
	return $pi;
}
