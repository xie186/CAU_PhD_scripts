#!/usr/bin/perl -w
use strict;

open R,$ARGV[0] or die;
my @aa=<R>;
close R;
my @bb;
foreach(@aa){
    if($_=~/^>/){
        push @bb,$_; 
    }else{
        chomp $_;
        push @bb,$_;
    }
}

my $seq=join('',@bb);
my @cc=split(/>/,$seq);
shift @cc;
foreach(@cc){
    print ">","$_\n" if /MAIZE/;
}
