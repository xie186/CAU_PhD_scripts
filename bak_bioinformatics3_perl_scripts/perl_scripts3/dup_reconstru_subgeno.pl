#!/usr/bin/perl -w
use strict;
my ($synmap,$reconstruct)=@ARGV;
die usage() unless @ARGV==2;
open RECON,$reconstruct or die "$!";
my %hash;
while(<RECON>){
    chomp;
    next if /#/;
    my ($sb,$zm,$subgeno)=split;
    ($sb)=(split(/_/,$sb))[1];
    ($zm)=(split(/_/,$zm))[1];
    $hash{"$sb\t$zm"}=$subgeno;
}

open DUPKS,$synmap or die "$!";
my @ks_file=<DUPKS>;
my $ks_file=join('',@ks_file);
   @ks_file=split(/##/,$ks_file);

shift @ks_file;

foreach(@ks_file){
    my @ks_line=split(/\n/,$_);
    my @pos_sb;
    my @pos_zm;
    shift @ks_line;
    my ($chr_sb,$chr_zm)=(0,0);
    foreach my $line(@ks_line){
        
        my ($sorghum,$zm)=(split(/\t/,$line))[1,5];
        next if (!$sorghum || !$zm);
        my ($chr1,$stt1,$end1,$ge_sb)=(split(/\|\|/,$sorghum))[0,1,2,3];
        my ($chr2,$stt2,$end2,$ge_zm)=(split(/\|\|/,$zm))[0,1,2,3];
 #       print "sb\t$chr1,$stt1,$end1,$ge_sb\nzm\t$chr2,$stt2,$end2,$ge_zm\n";
        push @pos_sb,($stt1,$end1);
        push @pos_zm,($stt2,$end2);
        ($chr_sb,$chr_zm)=($chr1,$chr2);
    }
    my ($min_sb,$max_sb)=(sort{$a<=>$b}@pos_sb)[0,-1];
    my ($min_zm,$max_zm)=(sort{$a<=>$b}@pos_zm)[0,-1];
    my $subgeno="NA";
       $subgeno=$hash{"$chr_sb\t$chr_zm"} if exists $hash{"$chr_sb\t$chr_zm"};
    print "$chr_sb\t$min_sb\t$max_sb\t$chr_zm\t$min_zm\t$max_zm\t$subgeno\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SynMap results> <Reconstructed>
DIE
}
