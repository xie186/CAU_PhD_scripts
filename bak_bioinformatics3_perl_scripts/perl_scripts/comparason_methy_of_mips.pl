#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==6;
my ($rabase,$gff,$forw,$rev,$out,$out2)=@ARGV;

die "$out exists!!!" if -e $out;
open OUT,"+>$out" or die "$!";

open MIPS,$rabase or die "$!";
my %id_rabase;
while(<MIPS>){
    chomp;
    my ($id,$name)=(split(/\|/,$_))[-2,-1];
    $id_rabase{$id}=$name;
    <MIPS>;
}
close MIPS;

my %methy;
open FORW,$forw or die "$!";
while(<FORW>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<3;
    $methy{"$chr\t$pos1"}=$level;
}
close FORW;

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<3;
    $methy{"$chr\t$pos1"}=$level;
}
close REV;

open GFF,$gff or die "$!";
my %mips;
while(<GFF>){
    chomp;
    next if /^#/;
    my ($chr,$stt,$end,$id)=(split(/\s+/,$_))[0,3,4,8];

#    next if $chr!=;                                                ###### 
       ($id)=$id=~/class=(.+)\;type/;
    $mips{$id_rabase{$id}}++;
    $chr=0 if $chr=~/UNKNOWN/;
    my ($meth_lev,$number)=(0,0);
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $methy{"chr$chr\t$i"}){
            $meth_lev+=$methy{$i};
            $number++;
        }
    }
    print OUT "$id\t$id_rabase{$id}\t$meth_lev\t$number\n";
    
}

open OUT2,"+>$out2" or die "$!";
foreach(keys %mips){
    print OUT2 "$_\t$mips{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Rabase> <MIPS GFF> <Forward> <Reverse> <OUT1> <OUT2> 
DIE
}
