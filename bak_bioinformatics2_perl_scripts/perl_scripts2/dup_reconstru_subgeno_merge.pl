#!/usr/bin/perl -w
use strict;
my ($subgeno,$out)=@ARGV;
die usage() unless @ARGV==2;
open SUB,"sort -k4,4n -k1,1n -k2,2n  $subgeno|" or die "$!";
my @line=<SUB>;
my $tem1=shift @line;
my ($chr1,$stt1,$end1,$sub_id1)=split(/\t/,$tem1);

open OUT,"+>$out" or die "$!";
PATH:{
    my $tem2=shift @line;
    if(!$tem2){
        print OUT "$chr1\t$stt1\t$end1\t$sub_id1";
    }else{
        my ($chr2,$stt2,$end2,$sub_id2)=split(/\t/,$tem2);
        if($chr2==$chr1){
            if($stt2<=$end1){
                ($stt1,$end1)=(sort{$a<=>$b}($stt1,$end1,$stt2,$end2))[0,-1];
            }else{
                print OUT "$chr1\t$stt1\t$end1\t$sub_id1";
                ($stt1,$end1)=($stt2,$end2);
            }
            
        }else{
            print OUT "$chr1\t$stt1\t$end1\t$sub_id1";
            ($chr1,$stt1,$end1,$sub_id1)=($chr2,$stt2,$end2,$sub_id2);
        }
        redo PATH;
    }
}
close OUT;

open OUT,"sort -k1,1n -k2,2n $out |" or die "$!";
my @line1=<OUT>;
my $tem2=shift @line1;
my ($chr2,$stt2,$end2,$sub_id2)=split(/\t/,$tem2);
PATH:{
    my $tem3=shift @line1;
    if(!$tem3){
        print "$chr2\t$stt2\t$end2\t$sub_id2";
    }else{

        my ($chr3,$stt3,$end3,$sub_id3)=split(/\t/,$tem3);
        if($chr3==$chr2){

            if($stt3<=$end2){
                ($stt2,$end2,$stt3,$end3) = sort{$a<=>$b}($stt2,$end2,$stt3,$end3);
                print  "$chr2\t$stt2\t$end2\t$sub_id2";
                ($chr2,$stt2,$end2,$sub_id2)=($chr3,$stt3,$end3,$sub_id3);
            }else{
                print "$chr2\t$stt2\t$end2\t$sub_id2";
                ($chr2,$stt2,$end2,$sub_id2)=($chr3,$stt3,$end3,$sub_id3);
            }

        }else{
            print "$chr2\t$stt2\t$end2\t$sub_id2";
            ($chr2,$stt2,$end2,$sub_id2)=($chr3,$stt3,$end3,$sub_id3);
        }
        redo PATH;
    }
}
close OUT;

sub usage{
    my $die=<<DIE;
    perl *.pl  <Subgenome middle>  >out
DIE
}
