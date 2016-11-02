#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($gene_pos,$imp,$non_code) = @ARGV;

open IMP,$imp or die "$!";
my %hash_imp;
while(<IMP>){
    chomp;
    $hash_imp{$_} ++;
}

my %hash_snp;
open POS,$gene_pos or die "$!";
while(<POS>){
    my ($chr,$stt,$end,$gene) = split;
    next if $chr !~/\d/;
    $chr = "chr".$chr if !/^chr/;
#    print "$chr\t$stt\t$end\n" if exists $hash_imp{$gene};
    $hash_snp{$chr} -> {$stt} = $end if exists $hash_imp{$gene};
}

open NON,$non_code or die "$!";
while(<NON>){
    chomp;
    my ($chr,$stt,$end) = split;
    $chr = "chr".$chr if !/^chr/;
    $hash_snp{$chr}->{$stt} = $end;
}

my $cluster_size = 2000000;
foreach my $chr (keys %hash_snp){
     my @pos = sort {$a<=>$b} (keys %{$hash_snp{$chr}});
     my $nu = @pos;
     for(my $i =0;$i < $nu; ++$i){
         my $flag = 1;
         my $stt1 = $pos[$i];
         my $end1 = $hash_snp{$chr} -> {$stt1};
         next if $end1 - $stt1+1 > $cluster_size;
         PATH:{
             if(!$pos[$i + 1]){
                 print "$chr\t$stt1\t$end1\t$flag\n" if ($end1 - $stt1 <= $cluster_size && $flag > 1); 
             }else{
                 $i+=1;
                 my $stt2 = $pos[$i];
                 my $end2 = $hash_snp{$chr} -> {$stt2};
                 if($end2 - $stt1 + 1 <= $cluster_size){
                     $end1 = $end2;
                     ++ $flag;
                     redo PATH;
                 }else{
                     print "$chr\t$stt1\t$end1\t$flag\n"if ($flag > 1);
		     $flag = 1;
                     $i+=1;
	             last if !$pos[$i];
                     $stt1 = $pos[$i];
                     $end1 = $hash_snp{$chr} -> {$stt1};
                     redo PATH;
                 }
             }
         } 
     }
}

sub usage{
    print <<DIE;
    perl *.pl <gene position> <imp gene name> <non code> 
DIE
    exit 1;
}
