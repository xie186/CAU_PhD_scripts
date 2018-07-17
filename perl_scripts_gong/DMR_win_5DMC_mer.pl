#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==1;
my ($merBed) = @ARGV;
open MER,$merBed or die "$!";
my %dm_win;
while(<MER>){
    chomp;
    my ($chr, $stt, $end, $id) = split;
    $id =~ s/;/_/g;
    $id =~ s/chr\d+\_//g;
    my @id =split(/_/, $id); 
    my ($tem_stt, $tem_end) = (sort{$a<=>$b} @id)[0, -1];
    print "$chr\t$tem_stt\t$tem_end\t$chr\_$tem_stt\_$tem_end\n";
}
close MER;

sub usage{
    my $die =<<DIE;
    perl *.pl <mergeBed> 
DIE
}
