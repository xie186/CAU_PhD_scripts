#!/usr/bin/perl -w
use strict;

my @bb=<>;

chomp @bb;
my $len=@bb;
print "$len\n";
foreach(@bb){
    print "$_\n";
}
my $aa='this is a baaby!';

my $dig=$aa=~s/i(s)//g;

print "$aa\t$dig\t$1\n";

