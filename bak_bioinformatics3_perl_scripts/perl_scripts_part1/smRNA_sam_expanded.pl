#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($sam) = @ARGV;
open SAM,$sam or die "$!";
while(<SAM>){
    chomp;
    if(/^@/){
        print "$_\n";
    }else{
        my ($id,$flag) = split;
        next if $flag == 4;
        my ($read_id,$len,$num) = split(/_/,$id);
        for(my $i =0;$i < $num;++$i){
            print "$_\n";
        } 
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <sam file> 
DIE
}
