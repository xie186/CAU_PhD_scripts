#!/usr/bin/perl -w
use strict;
my ($class1,$class2,$feature)=@ARGV;
die usage() unless @ARGV==3;
open CLA1,$class1 or die "$_";
my %hash_cla;
while(<CLA1>){
    chomp;
    my ($sn,$type)=split(/\t/);
    $hash_cla{$type}="CLASS1";
}
open CLA2,$class2 or die "$!";
while(<CLA2>){
    chomp; 
    my ($sn,$type)=split(/\t/);
    $hash_cla{$type}="CLASS2";
}
open FEA,$feature or die "$!";
my %mTE;my %uTE;my %mTE_dis;my %uTE_dis;my %TE;
while(<FEA>){
    chomp;
    my ($repeat,$c_cov,$meth,$c_nu,$dis)=(split(/\t/))[4,5,6,7,8];
    next if ($c_cov/($c_nu+0.0000001)<0.3 || $c_nu<10);
    if($meth<=0.1){
        $uTE{$repeat}++;
        $uTE_dis{$repeat}+=$dis;
    }else{
        $mTE{$repeat}++;
        $mTE_dis{$repeat}+=$dis;
    }
    $TE{$repeat}++;
}

print "Class\tFamily\tCopy_nu\tMedian_distance\tmethTE\tunmTE\tMedian_dis/methTE\tMedian_dis/unmTE\n";
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
    $uTE{$_}=0 if (!exists $uTE{$_});
    my $clas=$hash_cla{$_};
    print "$clas\t$_\t$TE{$_}\t$med_dis\t$mTE{$_}\t$uTE{$_}\t$med_dis_mTE\t$med_dis_uTE\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <CLASSI> <CLASSII> <Meth feature of TE>
    we use this to generate a table of TE methylation,include 
DIE
}
