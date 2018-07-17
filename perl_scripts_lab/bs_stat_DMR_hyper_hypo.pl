#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($bs_pair, $context) = @ARGV;
print "pair_cmp\tDMR_cov_hyper\tDMR_cov_hypo\tDMR_num_hyper\tDMR_num_hypo\n";
open PAIR, $bs_pair or die "$!";
while(<PAIR>){
   chomp;
   next if /#/;
   my ($wt, $mut) = split; 
   my ($cov_hyper, $cov_hypo, $num_hyper, $num_hypo) = (0, 0, 0, 0);
   open HYPER, "w100s100_$context\_$mut\_to_$wt.mer_hyper" or die "$!";
   while(my $line = <HYPER>){
       my ($chr,$stt,$end) = split(/\t/, $line);
       $cov_hyper += $end - $stt +1;
       ++$num_hyper;
   }
   close HYPER;

   open HYPER, "w100s100_$context\_$mut\_to_$wt.mer_hypo" or die "$!";
   while(my $line = <HYPER>){
       my ($chr,$stt,$end) = split(/\t/, $line);
       $cov_hypo += $end - $stt +1;
       ++ $num_hypo;
   }
   close HYPER;
   
   print "$mut\_vs\_$wt\t$cov_hyper\t$cov_hypo\t$num_hyper\t$num_hypo\n";
}

sub usage{
    my $die =<<DIE;
perl $0 <bs pair> <context> 
DIE
}
