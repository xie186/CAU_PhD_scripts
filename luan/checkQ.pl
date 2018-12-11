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
                        if ($q>30 || $q==30){
                            $high_q{$ff}++;
                        } elsif($q<30 && $q>10){
                            $mid_q{$ff}++;
                        }else{
                            $low_q{$ff}++;
                        }
#			print ord($one),"fisrt is $one\t$ff\t$hash{$ff}\n" if $ff==1;
		}
}

#print the high middle low $q ratio respectively

print "-------------------------HIGH--------------------------------\n";
foreach (sort {$a<=>$b} keys %high_q){
        print "\t\numuber\thigh_q\tmid_q\t\low_q";
	printf "\t%.3d\t%.3f\n\n",$_,$high_q{$_}/$rc;
}
print "-------------------------------------------------------------\n";

print "-------------------------MIDDLE----------------------------\n";
foreach (sort {$a<=>$b} keys %mid_q){
        printf "\t%.3d\t%.3f\n\n",$_,$mid_q{$_}/$rc;
}
print "-------------------------------------------------------------\n";

print "-------------------------LOW-------------------------------\n";
foreach (sort {$a<=>$b} keys %low_q){
        printf "\t%.3d\t%.3f\n\n",$_,$low_q{$_}/$rc;
}
print "-------------------------------------------------------------\n";





