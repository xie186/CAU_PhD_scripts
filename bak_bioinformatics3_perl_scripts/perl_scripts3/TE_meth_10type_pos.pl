#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV== 9;
my ($type10,$gff,$cpg_ot,$cpg_ob,$chg_ot,$chg_ob,$chh_ot,$chh_ob,$out) = @ARGV;
my %hash_type;
open TYPE,$type10 or die "$!";
while(<TYPE>){
    chomp;
    my ($type) = split;
    $hash_type{$type} ++ ;
}

my %meth_cpg;my %meth_chg;my %meth_chh;
foreach($cpg_ot,$cpg_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       @{$meth_cpg{"$chr\t$pos1"}}=($depth,$lev*$depth);
   }
   close BED;
}

foreach($chg_ot,$chg_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       @{$meth_chg{"$chr\t$pos1"}}=($depth,$lev*$depth);
   }
   close BED;
}

foreach($chh_ot,$chh_ob){
   open BED,$_ or die "$!";
   while (my $line=<BED>){
       chomp;
       my ($chr,$pos1,$pos2,$depth,$lev)=split(/\t/,$line);
       next if $depth<3;
       @{$meth_chh{"$chr\t$pos1"}}=($depth,$lev*$depth);
   }
   close BED;
}

open GFF,$gff or die "$!";
my %hash_te;
my %hash_pos;
while(<GFF>){
    chomp;
    my ($chr,$stt,$end,$strand,$type) =split; 
    next if !exists $hash_type{$type};
    for(my $i = $stt;$i<=$end;++$i){
        next if exists $hash_pos{"chr$chr\t$i"};
        $hash_pos{"chr$chr\t$i"} ++;
        if(exists $meth_cpg{"chr$chr\t$i"}){
            ${$hash_te{$type}}[0] += ${$meth_cpg{"chr$chr\t$i"}}[1];  # c_nu
            ${$hash_te{$type}}[1] += ${$meth_cpg{"chr$chr\t$i"}}[0];  # depth
        }
        if(exists $meth_chg{"chr$chr\t$i"}){
            ${$hash_te{$type}}[2] += ${$meth_chg{"chr$chr\t$i"}}[1];  # c_nu
            ${$hash_te{$type}}[3] += ${$meth_chg{"chr$chr\t$i"}}[0];  # depth
        }
        if(exists $meth_chh{"chr$chr\t$i"}){
            ${$hash_te{$type}}[4] += ${$meth_chh{"chr$chr\t$i"}}[1];  # c_nu
            ${$hash_te{$type}}[5] += ${$meth_chh{"chr$chr\t$i"}}[0];  # depth
        }
    }
}

open OUT,"+>$out" or die "$!";
foreach(keys %hash_te){
    my $lev_cpg = ${$hash_te{$_}}[0] / ${$hash_te{$_}}[1];
    my $lev_chg = ${$hash_te{$_}}[2] / ${$hash_te{$_}}[3];  
    my $lev_chh = ${$hash_te{$_}}[4] / ${$hash_te{$_}}[5];
    print OUT "$_\t$lev_cpg\t$lev_chg\t$lev_chh\n";
}
close OUT;
sub usage{
    print <<DIE;
    perl *.pl <type10> <gff> <cpg_ot> <cpg_ob> <chg_ot> <chg_ob> <chh_ot> <chh_ob> <out> 
DIE
   exit 1;
}
