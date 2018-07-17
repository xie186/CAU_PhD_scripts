#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==4;
foreach my $file2(@ARGV){
    my ($flank1,$flank2) = split(/,/, $file2);
    open FLANK, $flank1 or die "$!";
    my %flank1;
    my %flank1_no;
    while(<FLANK>){
        chomp;
        #hr1    3932901 3933000 8       8       0       0.338235294117647       .       -1      -1      .
        my ($chr,$stt,$end,$num1, $num2, $meth1,$meth2,$chr1,$stt1) = split;
        $flank1{"$chr\t$stt\t$end"} ++;
        $flank1_no{"$chr\t$stt\t$end"} ++ if $stt1 == -1;
    }
    close FLANK;
 
    open FLANK, $flank2 or die "$!";
    my %flank2;
    my %flank2_no;
    while(<FLANK>){
        chomp;
        #hr1    3932901 3933000 8       8       0       0.338235294117647       .       -1      -1      .
        my ($chr,$stt,$end,$num1, $num2, $meth1,$meth2,$chr1,$stt1) = split;
        $flank2{"$chr\t$stt\t$end"} ++;
        $flank2_no{"$chr\t$stt\t$end"} ++ if $stt1 == -1;
    }
   close FLANK;
   my ($mut) = $flank1 =~ /C.*_(.*)_to_c24/;
   my $nolap1 = keys %flank1_no || 0;
   my $tot1 = keys %flank1;
   my $nolap2 = keys %flank2_no || 0;
   my $tot2 = keys %flank2;
   my $ratio1 = ($tot1 - $nolap1)/$tot1;
   my $ratio2 = ($tot2 - $nolap2)/$tot2;
   print "$mut\t$ratio1\t$ratio2\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <1k:2k 156> <204> <nrpd1a> <ros1> 
DIE
}
