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
       $hash{$funame}++;
}

foreach (keys(%hash)){
#   print "$_\t$hash{$_}\n" if $hash{$_}>=5;
}
   open FASTA,$ARGV[1] or die;
   while(my $tran=<FASTA>){
      chomp $tran;
      my $seq=<FASTA>;
    if(! defined($hash{$tran})){
        print "$tran\n$seq";
    }elsif($hash{$tran}>=4){
 #       print "$tran\t$hash{$tran}\n";
        next;
   }else{
       print "$tran\n$seq";
   }
   }

