#!/usr/bin/perl -w
use strict;
sub usage{
    my $die =<<DIE;
    perl *.pl <Hapmap> <window size> > out 
DIE
}
die usage() unless @ARGV == 2;
my $win=$ARGV[1];
# slide window
my $nsite=0;
my $W=0;
my $st;
my $ed;
my $chr;
open F,"$ARGV[0]" or die;
while(<F>){
	while(<F>){
		next if /\-/;
		my $ck=check_snp($_);
		next if $ck<2;
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
#
sub check_snp{
	my $line=shift @_;
	my %hash;
	my @tem=split /\s+/,$line;
	for(my $x=11;$x<@tem;$x++){
		$hash{$tem[$x]}++ if $tem[$x]!~/N/;
	}
	my $num=0;
	$num=keys %hash;
	return $num;
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
                #If there is missing data (indicated by 'N' characters), the sample size is reduced for that site. For example, if the data for the  site is:
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
        ## website:http://molpopgen.org/software/libsequence/doc/html/classSequence_1_1PolySNP.html#aa7a5928fa637f5e7dad403c11a0967a3
	my $homo=($nref*($nref-1)+$nalt*($nalt-1))/($nsam*($nsam-1));
	my $pi=1-$homo;
	return $pi;
}
