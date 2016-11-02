#!/usr/bin/perl -w
use strict;
my ($imp,$dup)=@ARGV;
die usage() unless @ARGV==2;
open IMP,$imp or die "$!";
my %hash;
while(<IMP>){
    chomp;
    $hash{$_}++;
}

open DUP,$dup or die "$!";
while(<DUP>){
    next if (/^#/ || /^\n/);
    chomp;
    my ($gene1,$gene2)=(split)[-2,-3];
    print "$_\n" if(exists $hash{$gene1} ||exists $hash{$gene2});
}

sub usage{
    my $die=<<DIE;
    perl *.pl <IMP name> <duplicated gene>
DIE
}
