#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($te_pos,$ge_pos)=@ARGV;

my %hash_pos;
open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$name,$strand)=split;
    for(my $i=$stt-2001; $i <= $end+2000; ++$i){
        $hash_pos{"$chr\t$i"}++;
    }
}

open TE,$te_pos or die "$!";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$tem_strd,$type,$sub_type) = split;
    
    for(my $i=$stt; $i <= $end; ++$i){
        if(exists $hash_pos{"$chr\t$i"}){
            print "$_\n" ;
            last;
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE pos> <Gene position>
DIE
}
