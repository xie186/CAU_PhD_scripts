#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($te,$gff)=@ARGV;
open TE,$te or die "$!";
my %hash;
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand,$type)=split;
    my $mid=int (($stt+$end+1)/2);
    $hash{"$chr\t$mid"}=$type;
}

my %hash_cal;
my %hash_len;
my %hash_type;
my %hash_ele;
my %hash_pos;
open GFF,$gff or die "$!";
while(<GFF>){
    next if (/chromosome/ || /mRNA/ || /^Mt/ || /^Pt/ || /^#/);
    chomp;
    my ($chr,$tool,$ele,$stt,$end)=split;
    for(my $i = $stt; $i <= $end; ++$i){
        $hash_pos{"$chr\t$i"}++;
    }
}

open TE,$te or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand,$type)=split;
    for(my $i = $stt; $i <= $end; ++$i){
        $hash_pos{"$chr\t$i"}++;
    }
    my $mid=int (($stt+$end+1)/2);
    $hash{"$chr\t$mid"}=$type;
}

foreach my $type(sort (keys %hash_type)){
    print "\t$type";
}
print "\n";

foreach my $ele(keys %hash_ele){
    print "$ele\t";
    foreach my $type(sort (keys %hash_type)){
         $hash_cal{"$ele\t$type"}=0 if !exists $hash_cal{"$ele\t$type"};
         $hash_len{"$ele\t$type"}=0 if !exists $hash_len{"$ele\t$type"};
         my $aver = $hash_cal{"$ele\t$type"}*1000000/($hash_len{"$ele\t$type"}+0.0000001);
         print "$aver\t";
    }
    print "\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE position> <GFF>
DIE
}
