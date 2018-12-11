#!/usr/bin/perl -w
use strict;
die "usage:perl *.pl <ALLELE><SNPBWG><ALLELE_SNPBWG>" unless @ARGV==3;

open ALLELE,$ARGV[0] or die;
open SNPBWG,$ARGV[1] or die;
open ALESBG,"+>$ARGV[2]" or die;

my @allele=<ALLELE>;
my @allele_snpbw;
my $snpbw;
my $start='';
my $end='';

while($snpbw=<SNPBWG>){
#    print "OOOO\n";
    
PATH: {  foreach my $alle(@allele){

#        my($chr1,$pos1)=(split(/\s+/,$snpbw))[0,1];
###         print "IM HERE\n";      
        $start=@allele_snpbw;
        
        chomp $snpbw;
        my($chr1,$pos1)=(split(/\s+/,$snpbw))[0,1];

#        print "IM here\n";

        chomp $alle;
        my($chr2,$pos2)=(split(/\s+/,$alle))[0,1];
          
        if($chr1 ne $chr2){
 #           print "CCC\n";
            next;
        }elsif($pos1!=$pos2){
  #          print "DDDDDD\n";
            next;
        }else{
              
            push(@allele_snpbw,"$alle\n");
            $end=@allele_snpbw;

#            print "XXXXXXXXXXXXXXXX\n" if $end-$start==1;
       
            $snpbw=<SNPBWG>;
#           print "IM HERE\n";
            redo PATH;
        }
    }
   }
}
print ALESBG @allele_snpbw;
close ALLELE;
close SNPBWG;
close ALESBG;
