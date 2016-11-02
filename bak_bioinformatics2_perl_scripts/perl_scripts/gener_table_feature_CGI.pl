#!/usr/bin/perl -w
use strict;
my ($feature)=@ARGV;
die usage() unless @ARGV==1;
open FEA,$feature or die "$!";
my %mTE;my %uTE;my %mTE_dis;my %uTE_dis;my %TE;
my $repeat="CGI";
while(<FEA>){
    chomp;
    my ($meth,$dis)=(split(/\t/))[7,8];
    next if (/NA/);
    if($meth<=0.1){
        $uTE{$repeat}++;
        $uTE_dis{$repeat}+=$dis;
    }else{
        $mTE{$repeat}++;
        $mTE_dis{$repeat}+=$dis;
    }
    $TE{$repeat}++;
}

print "Family\tCopy_nu\tMedian_distance\tmethTE/unmTE\tMedian_dis/methTE\tMedian_dis/unmTE\n";
foreach(keys %TE){
    my ($med_dis_uTE,$med_dis_mTE)=(0,0);
    if(!exists $uTE_dis{$_}){
        $uTE_dis{$_}=0;
        $med_dis_uTE=0;
    }else{
        $med_dis_uTE=$uTE_dis{$_}/$uTE{$_};
    }

    if(!exists $mTE_dis{$_}){
        $mTE_dis{$_}=0;
        $med_dis_uTE=0;
    }else{
        $med_dis_mTE=$mTE_dis{$_}/$mTE{$_};
    }
    $mTE_dis{$_}=0 if !exists $mTE_dis{$_};
    my $med_dis=($uTE_dis{$_}+$mTE_dis{$_})/$TE{$_};
#     print "$_\t$TE{$_}\t$med_dis\t$mTE{$_}/$uTE{$_}\n";
    if (!exists $uTE{$_}){print "$_\n";}   
    print "$_\t$TE{$_}\t$med_dis\t$mTE{$_}/$uTE{$_}\t$med_dis_mTE\t$med_dis_uTE\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Meth feature of TE>
    we use this to generate a table of TE methylation,include 
DIE
}
