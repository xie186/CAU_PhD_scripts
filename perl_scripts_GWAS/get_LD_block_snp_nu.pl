#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($ld_block) = @ARGV;
open LD,$ld_block or die "$!";
my $i = 1;
while(<LD>){
    chomp;
    my @aa = split(/\s+/,$_);
    my $nu = @aa;
    my $tag_nu = $_ =~ s/!/!/g;
#    print "$_\n" if !$nu;
    print "$i\t$nu\t$tag_nu\n";
    ++ $i;
}
sub usage{
    print <<DIE;
    perl *.pl <LD block>
DIE
    exit 1;
}
