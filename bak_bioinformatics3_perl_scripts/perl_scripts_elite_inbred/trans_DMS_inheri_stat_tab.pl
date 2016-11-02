#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dms_stat, $context) = @ARGV;
my @dms_stat = split(/,/, $dms_stat);
my @context = split(/,/, $context);

for(my $i = 0; $i < @dms_stat; ++$i){
   open DMS, $dms_stat[$i] or die "$!"; 
   my ($tot, $stab) = (0, 0);
   while(<DMS>){
       chomp;
       my ($chr,$stt,$end,$geno1_c,$geno1_t,$geno2_c,$geno2_t,$lev1,$lev2,$diff,$pval,$qval, $stat) = split;  
       ++ $tot;
       ++ $stab if $stat eq "S";
   }
   my $perc = $stab/$tot;
   print "$context[$i]\t$tot\t$stab\t$perc\n";
   
}

sub usage{
    my $die = <<DIE;
    perl *.pl <DMS_status [file1,file2]> <context [file1,file2]>
DIE
}
