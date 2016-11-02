#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
my ($fish_res,$fdr,$out) = @ARGV;

open OUT,"+>$out" or die "$!";
open FISH,$fish_res or die "$!";
my @fish_p;
my $win_nu;
while(<FISH>){
    chomp;
    my @aa=split;
    push @fish_p,$aa[-1];
    print "$_\n" if !$aa[-1];
    ++$win_nu;
}

my @fish_p_sort= sort{$a<=>$b}@fish_p;
my $cut_nu = $fdr*$win_nu;

print  OUT "p_value\t$fish_p_sort[$cut_nu-1]\n";

my $number = 0;
foreach(0 .. $win_nu-1){
    ++$number if $fish_p_sort[$_] <=0.001;
}
my $tem = $number/$win_nu;
print OUT "p_value_0.001\tFDR: $tem\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <fisher's exact test> <FDR vaulue> <OUTPUT>
DIE
}
