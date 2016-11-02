#!/usr/bin/perl -w
use strict;
my ($synmap,$dup_pair,$nu)=@ARGV;
die usage() unless @ARGV==3;
open PAIR,$dup_pair or die "$!";
my %hash;
while(<PAIR>){
    chomp;
    next if /#/;
    my ($gene1,$sub1,$gene2,$sub2)=split;
    $hash{$gene1}="$_";
    $hash{$gene2}="$_";
}

open DUPKS,$synmap or die "$!";
my @ks_file=<DUPKS>;
my $ks_file=join('',@ks_file);
   @ks_file=split(/##/,$ks_file);

shift @ks_file;

my $flag=0;
foreach(@ks_file){
    ++$flag;
    next if $flag != $nu;
    my @ks_line=split(/\n/,$_);
    my @pos_sb;
    my @pos_zm;
    shift @ks_line;
    my ($chr_sb,$chr_zm)=(0,0);
    foreach my $line(@ks_line){
        my ($sorghum,$zm)=(split(/\t/,$line))[1,5];
        next if (!$sorghum || !$zm);
#        my ($chr1,$stt1,$end1,$ge_sb)=(split(/\|\|/,$sorghum))[0,1,2,3];
        my ($chr2,$stt2,$end2,$ge_zm)=(split(/\|\|/,$zm))[0,1,2,3];
 #       print "sb\t$chr1,$stt1,$end1,$ge_sb\nzm\t$chr2,$stt2,$end2,$ge_zm\n";
        print "$hash{$ge_zm}\n" if exists $hash{$ge_zm};
        
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SynMap results> <Duplicate gene pairs> <Number> 
DIE
}
