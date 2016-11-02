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
open F,$ARGV[0] or die;
while(<F>){
	while(<F>){
		next if /\-/;
                my $ck=check_snp($_);
                next if $ck<2;

		$nsite++;
		$st=(split)[3] if $nsite==1;
		$chr=(split)[2];

		$ed=(split)[3];
		$W+=$win/Wdenom($_);
		
		if($nsite==$win){
                        ## $W is important; $W/$win/($ed-$st) didn't make any sense;
			print "$chr\t$st\t$ed\t",$ed-$st,"\t$W\t",$W/$win/($ed-$st),"\n";
			$nsite=0;
			$W=0;
		}
	}
}
#

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
	my $line=shift @_;
	my @arr=split /\s+/,$line;
	my $nsam;
	for(my $x=11;$x<@arr;$x++){
		$nsam++ if $arr[$x]!~/N/;
	}
	my $sum;
	for(my $j=1;$j<$nsam-1;$j++){
                ## web site: http://molpopgen.org/software/libsequence/doc/html/classSequence_1_1PolySNP.html#af2a16b60017248d54bc96af95f48c092 
		$sum+=1/$j;
	}
	return $sum;
}
