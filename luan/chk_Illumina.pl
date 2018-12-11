#!/usr/bin/perl -w
use strict;
open F,$ARGV[0] or die"Cannot open the file:$!";

my $rc;

#
#set 3 hashes to be the access respectively
#
my %sanger_quality;                             #Quality not leess than 13
while(<F>){
	$_=<F>;                          #read one line of the file one by one  
	$_=<F>;
	$_=<F>;
		chomp;                   #rm the \n
               
		my @tem=split //,$_;    
		my $ff=0;                
#		print "doing $rc\t$_\n";
		foreach my $one(@tem){
			$ff++;
			my $q=ord($one)-64;
                        $sanger_quality{$ff}=$q;

               }      
}
print "Serial_number\tsanger_quality\n";

foreach (sort {$a<=>$b} keys %sanger_quality){
	printf "%.3d\t%.3d\n",$_,$sanger_quality{$_};
}
