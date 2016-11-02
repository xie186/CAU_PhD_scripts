#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($imp,$lap) = @ARGV;
open IMP,$imp or die "$!";
my %hash;
while(<IMP>){
    chomp;
    my ($chr,$stt,$end) = split;
    $hash{"$chr\t$stt\t$end"} ++;
}

my $flag = 0;
my @smRNA;
open LAP, $lap or die "$!";
while(<LAP>){
    chomp;
    my ($chr1,$stt1,$end1,$smrna1,$chr2,$stt2,$end2,$smrna2,$lap_nu2,$chr3,$stt3,$end3,$smrna3,$lap_nu3,$chr4,$stt4,$end4,$smrna4,$lap_nu4) = split;
    my @aa = sort {$a<=>$b} ($stt1,$end1,$stt2,$end2,$stt3,$end3,$stt4,$end4);
    if(exists $hash{"$chr1\t$aa[0]\t$aa[-1]"}){
        ++$flag;
        my $tem_join = join(';',($smrna1,$smrna3));
        my @tem_smRNA = split(/;/,$tem_join);
        push @smRNA,@tem_smRNA;
    }
}

my %hash_smRNA_len;
foreach(@smRNA){
    my ($id,$len,$nu) = split(/_/,$_);
    $hash_smRNA_len{$len} += $nu;
}

foreach(sort{$a<=>$b} keys %hash_smRNA_len){
    print "$_\t$hash_smRNA_len{$_}\n";
}

print "xx\t$flag\n";
sub usage{
    my $die=<<DIE;
    perl *.pl <imprinted smRNA> <Lap>  
DIE
}
