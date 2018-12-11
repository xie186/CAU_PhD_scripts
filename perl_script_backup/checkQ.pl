#!/usr/bin/perl -w
use strict;
open F,$ARGV[0] or die;
my $rc;
my %hash;
while(<F>){
    $_=<F>;
    $_=<F>;
    $_=<F>;
    chomp;
#		last if $rc==3;
    $rc++;
    my @tem=split //,$_;
    my $ff=0;
#   print "doing $rc\t$_\n";
    foreach my $one(@tem){
        $ff++;
        my $q=ord($one)-64;
        $hash{$ff}+=$q;
#print ord($one),"fisrt is $one\t$ff\t$hash{$ff}\n" if $ff==1;
     }
}
foreach (sort {$a<=>$b} keys %hash){
    print "$_\t",int $hash{$_}/$rc,"\n";
}
