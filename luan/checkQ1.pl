#!/usr/bin/perl -w
use strict;
open F,$ARGV[0] or die"Cannot open the file:$!";

my $rc;

#
#set 3 hashes to be the access respectively
#
my %low_q;
my %mid_q;
my %high_q;
while(<F>){
	$_=<F>;                          #read one line of the file one by one  
	$_=<F>;
	$_=<F>;
		chomp;                   #rm the \n
#		last if $rc==3;
		$rc++;                   #calculating the number of quality lines that have read
		my @tem=split //,$_;    
		my $ff=0;                
#		print "doing $rc\t$_\n";
		foreach my $one(@tem){
			$ff++;
			my $q=ord($one)-64;
			# caculate the
                        if ($q>20 || $q==20){
                            $high_q{$ff}++;
                        } elsif($q<20 && $q>10){
                            $mid_q{$ff}++;
                        }else{
                            $low_q{$ff}++;
                        }
#			print ord($one),"fisrt is $one\t$ff\t$hash{$ff}\n" if $ff==1;
		}
}

#print the high middle low $q ratio respectively

print "Serial_number\thigh_q\tmid_q\tlow_q\n";

foreach (sort {$a<=>$b} keys %high_q){
        $low_q{$_}=0 if $high_q{$_}/$rc +$mid_q{$_}/$rc ==1;
	printf "%.3d\t%.3f\t%.3f\t%.3f\n",$_,$high_q{$_}/$rc,$mid_q{$_}/$rc,$low_q{$_}/$rc;
}
