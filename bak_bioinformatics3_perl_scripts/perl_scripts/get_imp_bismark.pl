#!/usr/bin/perl -w
use strict;

die usage() if  @ARGV==0;
my ($pos,$imp,@remain)=@ARGV;
my $seor=pop @remain;
open POS,$pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $hash{$gene}=$_;
}

open IMP,$imp or die "$!";
print "#!/bin/sh\n";
while(<IMP>){
    chomp;
    if(exists $hash{$_}){
        my ($chr,$stt,$end,$gene,$strand)=split(/\s+/,$hash{$_});
    #    print 'awk \'$1=="chr$chr" && $2>=$stt-3000 && $2<=$end+3000\' @remain >test',"\n";
        my $aa='$3';
        my $bb='$4';
        $chr='chr'.$chr;
        $stt-=3000;
        $end+=3000;
        print  qq(awk '$aa=="$chr" && $bb>=$stt && $bb<=$end' @remain >>imp.$seor\n);
    }elsif($_=~/IES/){
        my ($chr,$stt,$end)=$_=~/IES_(chr\d+)_(\d+)_(\d+)/;
        my $aa='$3';
        my $bb='$4';
        $stt-=3000;
        $end+=3000;
        print  qq(awk '$aa=="$chr" && $bb>=$stt && $bb<=$end' @remain >>imp.$seor \n);
    }else{

    }
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Position> <Impinted gene> <Methy extract INT> <SE Or PE>
DIE
}
