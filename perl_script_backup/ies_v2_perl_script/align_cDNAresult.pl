#!/usr/bin/perl -w
use strict;
die "perl *pl <TRANScdna> <GENESEQcnda> <fasta> <ToFlcDNA> <NoFlcDNA>\n" unless @ARGV==5;
my ($to,$no)=($ARGV[-2],$ARGV[-1]);
open TRANS,$ARGV[0] or die;
my $tr=<TRANS>;
   $tr=<TRANS>;
   $tr=<TRANS>;
   $tr=<TRANS>;
   $tr=<TRANS>;
my %hash;
while($tr=<TRANS>){
   chomp $tr;
   my ($tr_nm,$cdna1,$cstt1,$cend1)=(split(/\s+/,$tr))[9,13,15,16];
   open GENES,$ARGV[1] or die "$!";
   my $ge=<GENES>;
      $ge=<GENES>;
      $ge=<GENES>;
      $ge=<GENES>;
      $ge=<GENES>;
   while($ge=<GENES>){
      chomp $ge;
      my ($ge_nm,$cdna2,$cstt2,$cend2)=(split(/\s+/,$ge))[9,13,15,16];
 #     my $find1=index($ge,$tr_nm,0);
       my $find2=index($ge,$cdna1,0);
 #      print "$find1\t$find2\n";
      if($find2>-1){
           $tr_nm="\>$tr_nm";
           $hash{$tr_nm}.="\t$ge_nm"; 
      }else{
          next;
      }
   }
}

open TO,"+>$to" or die "$!";
open NO,"+>$no" or die "$!";
open NONR,$ARGV[2] or die;
while(my $tr_name=<NONR>){
     chomp $tr_name;
     my $seq=<NONR>;
     my ($real_name)=split(/\t/,$tr_name);
  #  print "$hash{$tr_name}\n";
    if(exists ($hash{$real_name})){
        print TO "$real_name\t$hash{$real_name}\n$seq";
        print "xxx\n";
    }else{
        print NO "$real_name\n$seq";
    }
}
