#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($meth,$deg) = @ARGV;
open DEG,$deg or die "$!";
my %geno_pos;
while(<DEG>){
    chomp;
    my ($chr,$stt,$end,$gene_id,$strand) = split;
    for(my $i = $stt - 10000; $i < $end + 10000; ++$i){
        $geno_pos{"$chr\t$i"} ++;
    }
}

open METH,$meth or die "$!";
while(<METH>){
    chomp;
    my ($chr,$stt,$c_num,$t_num) = split;
    next if $c_num + $t_num < 5;
    print "$_\n" if exists $geno_pos{"$chr\t$stt"};
}

sub usage{
    my $die =<<DIE;
    perl *.pl <meth_infor> <DEG> 
DIE
}
