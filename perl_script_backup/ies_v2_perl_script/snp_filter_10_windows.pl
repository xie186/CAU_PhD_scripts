#!/usr/bin/perl
use strict;
use warnings;
die "Usage:perl *.pl <in.put> <OUT put>\n" unless @ARGV==2;
open SNP,$ARGV[0] or die "Cannot open:$!\n";
open OUT,"+>$ARGV[1]" or die "Cannot open:$!\n";
my @snp_array=<SNP>;
my $length=@snp_array;
#print "$length\n";
my @snp_filtered;
for(my $i=0;$i<$length-1;++$i){
    my @windows_one=split(/\s+/,$snp_array[$i]  );
    my @snp_neighbr=split(/\s+/,$snp_array[$i+1]);
    my $minus_neigh=$snp_neighbr[1]-$windows_one[1];
    if($windows_one[0] eq $snp_neighbr[0] && $minus_neigh<=9){
        ++$i;
        next;
     }else{
        print OUT "$snp_array[$i]";
     }
}
close SNP;
close OUT;
