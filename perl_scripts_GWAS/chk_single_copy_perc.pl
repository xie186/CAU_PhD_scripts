#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==3;
my ($psl,$cover_cut,$identity_cut)=@ARGV;
open PSL, $psl or die "$!";
my %hash;
while(<PSL>){
    chomp;
    next if !/^\d/;
    #188     0       0       0       0       0       0       0       +       region_chr2_12281758_12281945   188     0       188
    my ($match,$mismatch,$dot1,$dot2,$dot3,$dot4,$dot5,$dot6,$dot7,$id,$len,$stt,$end) = split;
    my $identity = $match / ($match + $mismatch);
    my $cover = ( $end - $stt + 1 )/ $len;
    $hash{$id} ++ if ($identity > $identity_cut && $cover > $cover_cut);
}

foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <psl> <cover_cut> <identity_cut>
DIE
}
