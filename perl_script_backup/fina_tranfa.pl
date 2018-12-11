#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <FA><RE>" unless @ARGV==2; 
open FA,$ARGV[0] or die;  #fasta file
open RE,$ARGV[1] or die;  #file about repetitive 

my $tran_name;
my $re_na;
my %hash;
while ($re_na=<RE>){
       chomp $re_na;
       my ($tran_na,$luan)=(split(/\s+/,$re_na))[0,1];
       print $tran_na;
       $hash{$re_na}++;
}

while ($tran_name=<FA>){
    my $seq=<FA>;
    chomp $tran_name;
    if(exists ($hash{$tran_name})){
        next;
    }else{
#        print "\>$tran_name\n$seq";
    }
    
}
