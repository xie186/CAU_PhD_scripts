#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($ge_pos,$geno_len,$repeats)=@ARGV;

my %fiv;my %thr;
open POS,"sort -k1,1 -k2,2n -k3,3n $ge_pos |" or die "$!";
while(my $line=<POS>){
    my ($chr1,$stt1,$end1)=split(/\s+/,$line);
    PATH:{
        $line=<POS>;
        if(!$line){
            $fiv{"chr$chr1\t$stt1"}=$stt1;
            $thr{"chr$chr1\t$end1"}=$end1;
        }else{
            my ($chr2,$stt2,$end2)=split(/\s+/,$line);
            if($chr2 eq $chr1 && $stt2>=$stt1 && $stt2<=$end1){
                $end1=$end2;
                redo PATH;
            }else{
                $fiv{"chr$chr1\t$stt1"}=$stt1;
                $thr{"chr$chr1\t$end1"}=$end1;
                ($chr1,$stt1,$end1)=($chr2,$stt2,$end2);
                redo PATH;
           }
        }
    }
}
open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $geno_len{$chr}=$len;
}
open GFF,$repeats or die "$!";
my %mips_nu;my %mips_dis;
while(<GFF>){
    chomp; 
    my ($chr,$stt,$end,)=split;
    next if $chr=~/chr0/;
    my ($flag1,$pos1,$flag2,$pos2,$dis)=(0,1,0,$geno_len{$chr},0);
#    my $mid=int (($stt+$end)/2);
    for(my $i=$stt;$i>0;--$i){
       if(exists $fiv{"$chr\t$i"}){
           $flag1=5;
           $pos1=$fiv{"$chr\t$i"};
           last;
       }
       if(exists $thr{"$chr\t$i"}){
           $flag1=3;
           $pos1=$thr{"$chr\t$i"};
           last;
       }
    } 
    for(my $i=$end;$i<=$geno_len{$chr};++$i){
       if(exists $fiv{"$chr\t$i"}){
           $flag2=5;
           $pos2=$fiv{"$chr\t$i"};
           last;
       }
       if(exists $thr{"$chr\t$i"}){
           $flag2=3;
           $pos2=$thr{"$chr\t$i"};
           last;
       }
    }
    if($flag1==3 && $flag2==5){
        my ($len1,$len2)=($stt-$pos1+1,$pos2-$end+1);
        my @aa=sort{$a<=>$b}($len1,$len2);
        $dis=$aa[0];
    }else{
        $dis=0;
    }
    print "$_\t$dis\n";
 
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Gene position> <Genome length> <trans file>
DIE
}
