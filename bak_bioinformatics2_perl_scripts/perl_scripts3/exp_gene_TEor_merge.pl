#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($prot,$intra,$down)=@ARGV;

open PROT,$prot or die "$!";
my %hash_prot;
my %hash_intra;
my %hash_down;
while(<PROT>){
    chomp;
    my ($chr,$stt,$end,$name,$strand,$type,$te_or)=split;
    $hash_prot{"$chr\t$stt\t$end\t$name\t$strand\t$type"}=$te_or;
}

open INTRA,$intra or die "$!";
while(<INTRA>){
    chomp;
    my ($chr,$stt,$end,$name,$strand,$type,$te_or)=split;
    $hash_intra{"$chr\t$stt\t$end\t$name\t$strand\t$type"}=$te_or;
}

open DOWN,$down or die "$!";
while(<DOWN>){
    chomp;
    my ($chr,$stt,$end,$name,$strand,$type,$te_or)=split;
    $hash_down{"$chr\t$stt\t$end\t$name\t$strand\t$type"}=$te_or;
}

foreach(keys %hash_prot){
    print "$_\t$hash_prot{$_}\t$hash_intra{$_}\t$hash_down{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Promoter> <Intragenic> <Downstream>
DIE
}
