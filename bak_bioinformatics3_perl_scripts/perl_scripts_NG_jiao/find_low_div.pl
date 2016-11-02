#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($snp, $chrm, $win, $step) = @ARGV;
open F,$ARGV[0] or die;
my %hash;
my @arr;
while(<F>){
    my @tem=split;
    next if $tem[0] ne $chrm;
    push @arr,$tem[1];
    $hash{$tem[1]}="$tem[2] $tem[3]";#$gt5003 $dp5003 $gt8112 $dp8112";
	
}
close F;

my $num=@arr;
for(my $x=0;$x<$num;$x += $step){
	my $diff = 0;
	my $same = 0;
	my $total = 0;
	for(my $y=0;$y < $win; $y++){
		exit if !$arr[$x+$y];
		my @gp=split /\s+/,$hash{$arr[$x+$y]};
		if($gp[0] ne "NN" && $gp[1] ne "NN"){
			$total++;
			if($gp[0] eq $gp[1]){
				$same++;
			}
			else{
				$diff++;
			}
		}
	}
	exit if !$arr[$x+1014];
	print "$chrm\t$arr[$x]\t",$arr[$x+1014],"\t$same\t$diff\t$total\t",$diff/$total,"\n";
}


sub usage{
    my $die =<<DIE;
    perl *.pl <snp> <chrom>  <windows size> <step size>
DIE
}
