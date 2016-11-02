#!/usr/bin/perl -w
use strict;
use warnings;

die "perl *.pl <SNP> <OUT>\n" unless @ARGV==2;
open F,$ARGV[0] or die;
open OUT,"+>$ARGV[1]" or die;
while(<F>){
	chomp;
#	print "it is $_\n";
	my @tem=split;
	my $dep1=$tem[3]+$tem[5];
	my $dep2=$tem[7]+$tem[9];
	next if $dep1<10 or $dep2<10;
#	my $pvalue=pop @tem;
#	print "$tem[2]##\t$tem[5]##\t$dep1##\t$dep2##\n";
#	$_=join "\t",@tem;
	my $pvalue1=test($tem[3],$tem[5]) || "NA";
	my $pvalue2=test($tem[9],$tem[7]) || "NA";
        
	print OUT "$tem[0]\t$tem[1]\t$tem[2]\t$tem[3]\t$tem[4]\t$tem[5]\t$tem[6]\t$tem[7]\t$tem[8]\t$tem[9]\t$pvalue1\t$pvalue2\n";
}


sub test{
        my $n1=shift @_;
        my $n2=shift @_;
        open R,"+>test.R";
        print R "chisq.test(c($n1,$n2),p=c(2/3,1/3));";
        close R;
        my $lines= `R --vanilla --slave < test.R`;
#	print "$lines\n";
#p-value = 0.04q986
	$lines=~/p-value \S+ (.*)/;
	return $1;
#       system "R --no-restore --no-save --no-readline < test.R > test.out";
#        open RO,"test.out" or die;
 #       while(my $ol=<RO>){
  #              if($ol=~/p-value \S (.*)/){
   #                     return $1;
    #            }
     #   }
}

