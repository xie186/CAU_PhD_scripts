#!/usr/bin/perl
use strict;
use warnings;
die usage() unless @ARGV==3;
my ($snp, $window,$out) = @ARGV;
open SNP,$snp or die "Cannot open:$!\n";
open OUT,"+>$out" or die "Cannot open:$!\n";
my @snp_array=<SNP>;
my $length=@snp_array;
#print "$length\n";
my @snp_filtered;
for(my $i=0;$i<$length-1;++$i){
    my @windows_one=split(/\s+/,$snp_array[$i]  );
    my @snp_neighbr=split(/\s+/,$snp_array[$i+1]);
    my $minus_neigh=$snp_neighbr[1]-$windows_one[1];
    if($windows_one[0] eq $snp_neighbr[0] && $minus_neigh <= $window - 1){
        ++$i;
        next;
     }else{
        print OUT "$snp_array[$i]";
     }
}
close SNP;
close OUT;

sub usage{
    print <<DIE;
    perl *.pl <novel snp> <window> <out>
DIE
   exit 1;
}
