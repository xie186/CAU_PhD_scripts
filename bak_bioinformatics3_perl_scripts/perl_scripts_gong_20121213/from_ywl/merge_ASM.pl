#!usr/bin/perl -w
use strict;
die usage() if @ARGV == 0;
open ASM,"sort -k1,1 -k2,2n $ARGV[0] |" or die;
open MERGE,"+>$ARGV[1]" or die;
while(<ASM>){
   next if /^chromosome/;
   my ($chr1,$stt1) = (split /\s+/,$_)[0,1];
   my $end1 = $stt1 + 2000;
   LABEL:{ 
            my $line = <ASM>;
            #$line = <ASM> if $line =~ /^chromosome/;
            last if(!defined $line);
            #print "$line";
            #sleep(2); 
            my ($chr2,$stt2) = (split /\s+/,$line)[0,1];
            my $end2 = $stt2 + 2000;
            #print"$stt2\t$end2\n";
            #sleep(2);
            if($chr1 eq $chr2 && $stt2<$end1){    
               $end1 = $end2;
               redo LABEL;
            }
            elsif($end1 - $stt1 > 2000){
               $end1 -= 2000;
               print MERGE "$chr1\t$stt1\t$end1\n";
            }
         }
} 

sub usage{
   my $die = <<DIE;
   perl *.pl <ASM> <MERGE>
DIE
}
