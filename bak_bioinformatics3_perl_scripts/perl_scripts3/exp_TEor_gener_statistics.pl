#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($in,$tis)=@ARGV;
open IN,$in or die "$!";
my %hash;
while(<IN>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$te,$rpkm)=split;
    if($rpkm>0){
        ${$hash{$te}}[0]++;
    }else{
        ${$hash{$te}}[1]++;
    }
}


print "$tis\tExp\tNon-exp\tPercentage\n";
foreach(keys %hash){
    my $perc=${$hash{$_}}[0]/(${$hash{$_}}[0]+${$hash{$_}}[1]);
    print "$_\t${$hash{$_}}[0]\t${$hash{$_}}[1]\t$perc\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene associated regions with or without TEs> <Tissue>
DIE
}
