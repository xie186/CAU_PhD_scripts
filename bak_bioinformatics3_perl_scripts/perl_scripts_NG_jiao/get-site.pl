#!/usr/bin/perl -w
use strict;
die "perl *.pl <windows>\n" unless @ARGV ==1;
my ($win_file) = @ARGV;
open T,"$win_file" or die "$!";
my @nn=<T>;
close T;

my $n=@nn;
print "$nn[0]";

for(my $i=1;$i<$n-1;$i++){
    my @ff1=split/\s+/,$nn[$i];
    my @ff2=split/\s+/,$nn[$i+1];
    print "$nn[$i]";
  
    @ff1=reverse @ff1;
    @ff2=reverse @ff2;
  
    if($ff1[1] >= $ff1[0] && $ff2[1] < $ff2[0]){
        print "##\n";
    }

    if($ff1[1]<$ff1[0] && $ff2[1]>=$ff2[0]){
        print "##\n";}
    }

print "$nn[$n-1]";

