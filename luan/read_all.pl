#!/usr/bin/perl -w
use strict;

open (READALL,"test.txt") or die "Cannot open the file:$!";
    $/=undef;
    my $read=<READALL>;
    print "$read\n";

