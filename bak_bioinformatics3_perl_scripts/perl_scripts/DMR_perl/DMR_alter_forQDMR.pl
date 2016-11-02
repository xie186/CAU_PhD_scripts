#!/usr/bin/perl -w
use strict;
my ($merged)=@ARGV;
die usage() unless @ARGV==1;
open MER,$merged or die "$!";
print "ID\tchr\tstt\tend\tsd\tem\tendo\t\n";
my $i=1;
while(<MER>){
    chomp;
    my ($chr,$stt,$end,$nu1,$lev1,$nu2,$lev2,$nu3,$lev3)=split;
    next if ($nu1<5 ||$nu2<5||$nu3<5);
    print "$i\t$chr\t$stt\t$end\t$lev1\t$lev2\t$lev3\n";
    ++$i;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR>  >DMR_forQDMR
DIE
}
