#!/usr/bin/perl -w
use strict;
die "Usage:perl *.pl <BLATPLS><FASTA_TRANS>" unless @ARGV==2;
open BLATPLS,$ARGV[0] or die;
#open FASTA,$ARGV[1] or die;
my $head=<BLATPLS>;
$head=<BLATPLS>;
$head=<BLATPLS>;
$head=<BLATPLS>;
$head=<BLATPLS>;
my %hash;
my $funame;
while(<BLATPLS>){ 
    next if !$_; 
    chomp $_;
    my ($match,$name,$length)=(split(/\s+/,$_))[0,9,10];
    $funame=join('', (">",$name));
#    print "$funame\n";
       $hash{$funame}++ if $match/$length>=0.7;
}

foreach (keys(%hash)){
}
   open FASTA,$ARGV[1] or die;
   while(my $tran=<FASTA>){
      chomp $tran;
      my $seq=<FASTA>;
    if( exists $hash{$tran}){
       next; 
    }else{
       print "$tran\n$seq";
    }
}

