#!/usr/bin/perl -w
use strict;

my ($tis,$seq)=@ARGV;

open SEQ,$seq or die "$!";
<SEQ>;
my $seq = <SEQ>;
my $stt=0;
$len = length $seq;
my @cpg_pos;
while($stt < $len){
    my $find=index($seq,"CG",$stt);
    push @cpg_pos,$find;
    $stt = $find + 1;
}

$stt=0;
my @chg_pos;
while($stt < $len){
    my $find=index($seq,"CAG",$stt);
    push @chg_pos,$find;
    $stt = $find + 1;
}

$stt=0;
my @chg_pos;
while($stt < $len){
    my $find=index($seq,"CTG",$stt);
    push @chg_pos,$find;
    $stt = $find + 1;
}

$stt=0;
my @chg_pos;
while($stt < $len){
    my $find=index($seq,"CCG",$stt);
    push @chg_pos,$find;
    $stt = $find + 1;
}

my @c_pos;
push @c_pos,@cpg_pos;
push @c_pos,@chg_pos;

@c_pos=sort{$a<=>$b}@c_pos;

foreach(){
    
}
