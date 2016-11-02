#!/usr/bin/perl -w
use strict;
use SVG;
my ($geno_len,$dmr)=@ARGV;
die usage() unless @ARGV==2;
open LEN,$geno_len or die "$!";
my $gra=SVG->new(width=>5000,height=>2600);
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $hash{$len}=$chr;
}
my @len=sort{$a<=>$b}(keys %hash);
my $max=$len[-1];
my $unit=4800/$max;
my $init_height=20;
my $nu=0;
my %height;
foreach(@len){
    $gra->rect(x=>100,y=>$init_height+$nu*200,width=>$unit*$_,height=>180,fill=>"lightblue",stroke=>"lightblue");
    $gra-> text('x',0,'y',$init_height+$nu*200,style=>{'font','Arial','font-size',78})->cdata("$hash{$_}");
    $height{$hash{$_}}=$init_height+$nu*200;
    $nu++;
}

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end)=split;
    $gra->rect(x=>100+$unit*$stt,y=>$height{$chr},width=>$unit*($end-$stt+1),height=>180,fill=>"red",stroke=>"red",'stroke-width'=>0.5);
}

print $gra->xmlify();

sub usage{
    my $die=<<DIE;
    perl *.pl <Maize genome length> <Regions analyzed>
DIE
}
