#!/usr/bin/perl -w 
use strict;

sub usage{
    my $die =<<DIE;
    perl *.pl <pvp_chr1.pi> <pvp_chr1.w> <inbred line number> 
DIE
}
die usage() unless @ARGV ==3;
my $sample=$ARGV[2];
my $den=denom($sample);

open PI,$ARGV[0] or die;
open W,$ARGV[1] or die;
while(my $aa=<PI>){
	my $bb=<W>;
	my ($chr,$st,$ed,$len,$pi)=split /\s+/,$aa;
	my $w=(split /\s+/,$bb)[4]/200;
	my $D=($pi-$w)/$den;
	print join "\t",($chr,$st,$ed,$len,$D,$pi,$w);
	print "\n";
}

sub denom{
	my $a1;
	my $a2;
	my $nsam=shift @_;# sample size
	my $seq=200;# window size
	for(my $i=1;$i<$nsam;$i++){
		$a1+=1/$i;	
		$a2+=1/($i*$i);
	}
	my $b1=($nsam+1)/(3*($nsam-1));
	my $b2=2*($nsam*$nsam+$nsam+3)/(9*$nsam*($nsam-1));
	
	my $c1=$b1-1/$a1;
	my $c2=$b2-($nsam+2)/($a1*$nsam)+$a2/($a1*$a1);
	
	my $e1=$c1/$a1;
	my $e2=$c2/($a1*$a1+$a2);
	my $denom=sqrt($e1*$seq+$e2*$seq*($seq-1));
	return $denom;
}
