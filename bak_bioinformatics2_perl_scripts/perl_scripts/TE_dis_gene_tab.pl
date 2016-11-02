#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($te,$gff)=@ARGV;
open TE,$te or die "$!";
my %hash;
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand,$type)=split;
    my $mid=int (($stt+$end+1)/2);
    $hash{"$chr\t$mid"}=$type;
}

my %hash_cal;
my %hash_len;
my %hash_type;
my %hash_ele;
open GFF,$gff or die "$!";
while(<GFF>){
    next if (/chromosome/ || /mRNA/ || /^Mt/ || /^Pt/ || /^#/);
    chomp;
    my ($chr,$tool,$ele,$stt,$end)=split;
    $hash_len{"$ele"}+=$end-$stt+1;
    for(my $i = $stt; $i <= $end; ++$i){
        next if !exists $hash{"$chr\t$i"};
        my $type=$hash{"$chr\t$i"};
        $hash_cal{"$ele\t$type"}++;
#        $hash_len{"$ele"}+=$end-$stt+1;
        $hash_type{$type}++;
        $hash_ele{$ele}++;
    }
}

foreach my $ele(sort (keys %hash_ele)){
    print "\t$ele";
}
print "\n";

foreach my $type(keys %hash_type){
    print "$type\t";
    foreach my $ele(sort (keys %hash_ele)){
         $hash_cal{"$ele\t$type"}=0 if !exists $hash_cal{"$ele\t$type"};
         my $aver = $hash_cal{"$ele\t$type"}*1000000/($hash_len{"$ele"}+0.0000001);
         print "$aver\t";
    }
    print "\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE position> <GFF>
DIE
}
