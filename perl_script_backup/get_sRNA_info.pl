#!/usr/bin/perl -w
use strict;
die "Usage:perl *pl <BLAST>\n" unless @ARGV==1; 
#use this to get the blast -m8 file info sRNA
open BLAS,$ARGV[0] or die;
while (<BLAS>){
    next if !$_;
    chomp $_;
#    print "$_\n";
    my ($sub,$iden,$len,$mis,$gap)=(split(/\s+/,$_))[1,2,3,4,5];
#    print "$sub\t$iden\t$len\t$mis\t$gap\n";
    my ($rna)=(split(/\-/,$sub))[1];
    my($rna_len)=(split(/\//,$rna))[0];   
#    print "$rna_len\t$len\n";
    if($rna_len==$len && $iden==100.00 && $mis==0 && $gap==0){
        print "$_\n";
    }
}

