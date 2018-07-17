#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($res, $out1, $out2) = @ARGV;
sub usage{
    my $die =<<DIE;
perl *.pl <res> <out RAxML> <out2 MrBayes> 
DIE
}
open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
my @mr_bayes;
open RES, $res or die "$!";
my $flag = 0;
while(<RES>){
    chomp;
    if(/RaxML-style partition definitions/){
        ++$flag;
        next;
    }
    #RaxML-style partition definitions
    #DNA, p1 = 1-39\3, 40-57\3, 592-627\3
    next if $flag ==0;
    my ($seq_type, $partition) = split(/,/, $_, 2);
    print OUT1 "$_\n";
    $partition =~ s/,//g;
    my ($p_name) = split(/=/, $partition);
    push @mr_bayes, $p_name;
    print OUT2 "charset $partition;\n";
}

my $number = @mr_bayes;
my $list = join(",", @mr_bayes);
print OUT2 "partition favored = $number: $list;\n";
print OUT2 "set partition = favored;\n";

close RES;
close OUT1;
close OUT2;
