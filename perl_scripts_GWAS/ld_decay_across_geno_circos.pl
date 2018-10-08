#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==1;
my ($ld_decay) = @ARGV;
open LD,$ld_decay or die "$!";
while(<LD>){
    chomp;
    $_ =~ s/chr/zeam/;
    my ($chr,$pos,$coef,$decay) = split; 
    $decay =int $decay;
    my ($stt,$end) = ($pos - 500000,$pos + 500000);
    print "$chr\t$stt\t$end\t$decay\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <LD decay> 
DIE
}
