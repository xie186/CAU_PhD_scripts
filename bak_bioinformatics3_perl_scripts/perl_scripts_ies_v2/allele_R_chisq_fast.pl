#!/usr/bin/perl -w
use strict;
use warnings;

die usage() unless @ARGV==2;
my ($alle4, $out) = @ARGV;
open F,$alle4 or die;
my $tem_out = $out;
   $tem_out =~ s/chisq/R/g;
open OUT,"+>$tem_out" or die;
#my $number;
while(<F>){
	chomp;
#	print "it is $_\n";
	my @tem=split;
	my $dep1=$tem[2]+$tem[3];
	my $dep2=$tem[4]+$tem[5];
	next if $dep1<10 or $dep2<10;
        print OUT "p_value1<-chisq.test(c($tem[2],$tem[3]),p=c(2/3,1/3))\$p.value\np_value2<-chisq.test(c($tem[5],$tem[4]),p=c(2/3,1/3))\$p.value\ncat(\"$_\",\"\\t\",as.character(p_value1),\"\\t\",as.character(p_value2),\"\\n\")\n";
}
 
system("R --vanilla --slave < $tem_out > $out");
#print "$number\n";
sub usage{
    print <<DIE;
    perl *.pl <snp allele 4 infor> <OUTPUT>
DIE
    exit 1;
}

