#!usr/bin/perl -w
use strict;
die usage() unless @ARGV == 5;
open FISH,$ARGV[0] or die;
open PASM_M,"+>$ARGV[1]" or die;
open PASM_P,"+>$ARGV[2]" or die;
open SASM_B,"+>$ARGV[3]" or die;
open SASM_M,"+>$ARGV[4]" or die; 
print PASM_M "chromosome\tposition\tBM-B73numberC\tBM-B73numberT\tBM-Mo17numberC\tBM-Mo17numberT\tMB-B73numberC\tMB-B73numberT\tMB-Mo17numberC\tMB-Mo17numberT\tmethylrateBM_B\tmethylrateBM_M\tmethylrateMB_B\tmethylrateMB_M\tBM-p\tMB-p\n";
print PASM_P "chromosome\tposition\tBM-B73numberC\tBM-B73numberT\tBM-Mo17numberC\tBM-Mo17numberT\tMB-B73numberC\tMB-B73numberT\tMB-Mo17numberC\tMB-Mo17numberT\tmethylrateBM_B\tmethylrateBM_M\tmethylrateMB_B\tmethylrateMB_M\tBM-p\tMB-p\n";
print SASM_B "chromosome\tposition\tBM-B73numberC\tBM-B73numberT\tBM-Mo17numberC\tBM-Mo17numberT\tMB-B73numberC\tMB-B73numberT\tMB-Mo17numberC\tMB-Mo17numberT\tmethylrateBM_B\tmethylrateBM_M\tmethylrateMB_B\tmethylrateMB_M\tBM-p\tMB-p\n";
print SASM_M "chromosome\tposition\tBM-B73numberC\tBM-B73numberT\tBM-Mo17numberC\tBM-Mo17numberT\tMB-B73numberC\tMB-B73numberT\tMB-Mo17numberC\tMB-Mo17numberT\tmethylrateBM_B\tmethylrateBM_M\tmethylrateMB_B\tmethylrateMB_M\tBM-p\tMB-p\n";
<FISH>;
while(<FISH>){
   my ($chr,$position,$BM_B73numberC,$BM_B73numberT,$BM_Mo17numberC,$BM_Mo17numberT,$MB_B73numberC,$MB_B73numberT,$MB_Mo17numberC,$MB_Mo17numberT,$fishBM,$fishMB) = split;
   next if $fishBM >= 0.05 || $fishMB >= 0.05;
   my $methylrateBM_B = $BM_B73numberC/($BM_B73numberC + $BM_B73numberT);
   my $methylrateBM_M = $BM_Mo17numberC/($BM_Mo17numberC + $BM_Mo17numberT);
   if(($methylrateBM_B < 0.5 && $methylrateBM_M > 0.5) || ($methylrateBM_B > 0.5 && $methylrateBM_M < 0.5)){
      if($methylrateBM_B > 2*$methylrateBM_M || $methylrateBM_M > 2*$methylrateBM_B){
         my $methylrateMB_B = $MB_B73numberC/($MB_B73numberC + $MB_B73numberT); 
         my $methylrateMB_M = $MB_Mo17numberC/($MB_Mo17numberC + $MB_Mo17numberT);
         if(($methylrateMB_B < 0.5 || $methylrateMB_M > 0.5) || ($methylrateMB_B > 0.5 && $methylrateMB_M < 0.5)){
            if($methylrateMB_B > 2*$methylrateMB_M || $methylrateMB_M > 2*$methylrateMB_B){
               if($methylrateBM_B > $methylrateBM_M && $methylrateMB_B < $methylrateMB_M){                  
                  print PASM_M "$chr\t$position\t$BM_B73numberC\t$BM_B73numberT\t$BM_Mo17numberC\t$BM_Mo17numberT\t$MB_B73numberC\t$MB_B73numberT\t$MB_Mo17numberC\t$MB_Mo17numberT\t$methylrateBM_B\t$methylrateBM_M\t$methylrateMB_B\t$methylrateMB_M\t$fishBM\t$fishMB\n";
               }
               if($methylrateBM_B < $methylrateBM_M && $methylrateMB_B > $methylrateMB_M){
                  print PASM_P "$chr\t$position\t$BM_B73numberC\t$BM_B73numberT\t$BM_Mo17numberC\t$BM_Mo17numberT\t$MB_B73numberC\t$MB_B73numberT\t$MB_Mo17numberC\t$MB_Mo17numberT\t$methylrateBM_B\t$methylrateBM_M\t$methylrateMB_B\t$methylrateMB_M\t$fishBM\t$fishMB\n";
               }
               if($methylrateBM_B > $methylrateBM_M && $methylrateMB_B > $methylrateMB_M){
                  print SASM_B "$chr\t$position\t$BM_B73numberC\t$BM_B73numberT\t$BM_Mo17numberC\t$BM_Mo17numberT\t$MB_B73numberC\t$MB_B73numberT\t$MB_Mo17numberC\t$MB_Mo17numberT\t$methylrateBM_B\t$methylrateBM_M\t$methylrateMB_B\t$methylrateMB_M\t$fishBM\t$fishMB\n";
               }
               if($methylrateBM_B < $methylrateBM_M && $methylrateMB_B < $methylrateMB_M){
                  print SASM_M "$chr\t$position\t$BM_B73numberC\t$BM_B73numberT\t$BM_Mo17numberC\t$BM_Mo17numberT\t$MB_B73numberC\t$MB_B73numberT\t$MB_Mo17numberC\t$MB_Mo17numberT\t$methylrateBM_B\t$methylrateBM_M\t$methylrateMB_B\t$methylrateMB_M\t$fishBM\t$fishMB\n"; 
               }
            }
         }
      }
   }
} 

sub usage{
   my $die = <<DIE;
   usage:perl *.pl <FISH> <PASM_M> <SASM_P> <SASM_B> <SASM_M>
DIE
}  
