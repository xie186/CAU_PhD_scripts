##############################################################################################
#To count the methylationg context fraction espectively,which was used to draw a pie graphic;
##############################################################################################
#!/usr/bin/perl -w
use strict;
#count the CG,CHG,CHH methylation fraction respectivly
my $cg;my $chh;my $chg;
my $methCG;my $methCHH;my $methCHG;
foreach(@ARGV){ 
 open PST,$_ or die;
 while(my $pst=<PST>){
     chomp $pst;
     my ($pos,$bb,$methlev)=(split(/\s+/,$pst))[1,3,4];
     my ($text,$read)=(split(/:/,$bb))[0,1];
     if($text eq "CG"){
         $cg++;
         if($methlev>0){
             $methCG++;
         }
     }elsif($text eq "CHG"){
         $chg++;
         if($methlev>0){
             $methCHG++;
         }
     }else{
         $chh++;
         if($methlev>0){
             $methCHH++;
         }
     }
 }
}
#calculate the methylation content in each xontext
my $cgtent =$methCG/$cg;
my $chgtent=$methCHG/$chg;
my $chhtent=$methCHH/$chh;
printf ("CG\tCHG\tCHH\n%.3f\t%.3f\t%.3f\n",$cgtent,$chgtent,$chhtent);

#calculate the fraction of methylcytocines in each sequence context
my $cgfrac =$methCG/($methCG+$methCHG+$methCHH);
my $chgfrac=$methCHG/($methCG+$methCHG+$methCHH);
my $chhfrac=$methCHH/($methCG+$methCHG+$methCHH);
printf("CG\tCHG\tCHH\n%.3f\t%.3f\t%.3f\n",$cgfrac,$chgfrac,$chhfrac);

