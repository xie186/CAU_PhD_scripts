#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($ies,$pos)=@ARGV;

open IES,$ies or die "$!";
while(my $name=<IES>){
    my $seq=<IES>;
    chomp $name;
    my ($chr,$pos1,$pos2)=$name=~/IES_(chr\d+)_(\d+)_(\d+)/;
#    $name=~s/>//;                      
    $chr=~s/chr//;                       
    open POS,$pos or die "$!";
    while(my $line=<POS>){
        chomp $line;
        my ($ge_chr,$stt,$end,$ge_name,$strand)=split(/\s+/,$line);
        next if ($ge_chr eq "Mt"||$ge_chr eq "Pt" );
        $ge_chr=0 if $ge_chr eq "UNKNOWN";
        if($ge_chr==$chr && $stt>=$pos1-50000 && $end<=$pos2+50000){
          print "$line\t$chr\t$pos1\t$pos2\tIES_chr$ge_chr","_$pos1","_$pos2","\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <IES>  <Genepos>
DIE
}
