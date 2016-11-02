#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($meth) = @ARGV;
open METH,$meth or die "$!";
while(<METH>){
    chomp;
    next if !/^chr/;
    my ($id,$meth1,$meth2,$meth3,$meth4) = split;
    $id =~ s/_/\t/g;
    if($meth3 - $meth1 > 0.3){
        print "$id\tIdentical\n";
    }else{
        print "$id\tNon-identical\n";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <Meth> 
DIE
}

