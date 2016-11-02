#!/usr/bin/perl -w
die usage() unless @ARGV == 2;
my $sam=$ARGV[1];
open F,$ARGV[0] or die;
$_=<F>;
while(<F>){
	my @tem=split;
	my ($ref,$alt)=$tem[1]=~/(\w)\/(\w)/;
	$ref="$ref$ref";
	$alt="$alt$alt";

	my $num1=$_=~s/$ref/$ref/g;
	my $num2=$_=~s/$alt/$alt/g;
	
#	($num1,$num2)=sort {$a<=>$b} ($num1,$num2);
	if($num1>$num2){
		my $rate=$num2/($num1+$num2);
		print "$tem[2]\t$tem[3]\t$tem[1]\t$alt\t$ref\t$num2\t$num1\t$rate\n" if $num1>=$sam/2;
	}
	else{
		my $rate=$num1/($num1+$num2);
		print "$tem[2]\t$tem[3]\t$tem[1]\t$ref\t$alt\t$num1\t$num2\t$rate\n" if $num2>=$sam/2;
	}
}
close F;

sub usage{
    my $die =<<DIE;
    perl *.pl <hapmap> <inbred line number> 
DIE
}
