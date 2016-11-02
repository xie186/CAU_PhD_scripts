#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($cri2,$tran,)=@ARGV;

open TR,$tran or die "$!";
while(my $line=<TR>){
    chomp $line;
    my ($chr,$stt,$end)=$line=~/IES_(chr\d+)_(\d+)_(\d+)/;
    my $seq=<TR>;
    
    my $flag=0;
    open SNP,$cri2 or die "$!";
    while(my $snp=<SNP>){
        chomp $snp;
        my ($chr_snp,$pos)=split(/\s+/,$snp);
        if($chr_snp eq $chr && $pos>=$stt && $pos<=$end){
            $flag++;
        }
    }
    if($flag>0){
        print "$line\n$seq";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Criteria 2 SNP > <Transcripts seq>
DIE
}
