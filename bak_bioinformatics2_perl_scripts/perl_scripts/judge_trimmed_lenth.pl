#!/usr/bin/perl -w
use strict;

die usage() if @ARGV==0;

my $mini=100;
while(<>){
    <>;
    my $len=length $_;
    $mini=$len if $len<$mini;
    <>;
    <>;
}

print "$mini\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <Reads_trimmed>
DIE
}
