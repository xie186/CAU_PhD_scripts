#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my($gene,$snp)=@ARGV;

open SEQ,$gene or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   $join =~ s/>//;
   @aa=split(/>/,$join);
my %hash;
foreach(@aa){
    my ($name,@seq)=split(/\n/,$_);
       my $seq=join'',@seq;
       $hash{$name} = $seq;
}

open SNP,$snp or die "$!";
<SNP>;
while(<SNP>){
    my ($chr,$pos,$alle1,$alle2) = split;
    my ($stt,$end) = ($pos - 50, $pos + 50);
    my $seq = substr($hash{$chr}, $stt - 1, $end - $stt + 1);
    print ">$chr\_$stt\_$end\_$pos\n$seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene Seq> <SNP pos>
DIE
}
