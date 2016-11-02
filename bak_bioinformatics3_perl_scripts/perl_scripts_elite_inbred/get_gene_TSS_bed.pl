#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($gene_pos) = @ARGV;
open POS,$gene_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split;
    if($strand eq "+"){
        $end = $stt + 1;
    }else{
        $stt = $end - 1;
    }
    print "$chr\t$stt\t$end\t$gene\t$strand\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <gene position>
DIE
}
