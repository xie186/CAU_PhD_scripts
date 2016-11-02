#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($snp,$trans) = @ARGV;
open SNP,$snp or die "$!";
my %hash_pos;
while(<SNP>){
    chomp;
    my ($chr,$pos,$ref,$alt) = split;
    $hash_pos{"$chr\t$pos"} = "$ref\t$alt";
}

open TRAN,$trans or die "$!";
while(<TRAN>){
    chomp;
    my ($chr,$stt,$end,$trans) = split;
    for(my $i = $stt; $i <= $end;++$i){
        my $pos = $i - $stt +1;
        print "$chr\t$stt\t$end\t$trans\t$pos\t$hash_pos{\"$chr\t$i\"}\n" if exists $hash_pos{"$chr\t$i"};
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <snp> <trans>
DIE
}
