#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($ge_pos,$geno_len,$repeats)=@ARGV;

open POS,"sort -k1,1 -k2,2n -k3,3n $ge_pos |" or die "$!";
my %fiv;my %thr;
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
    $chr=~s/chr//g;
    $geno_len{$chr}=$len;
}
open GFF,$repeats or die "$!";
my %mips_nu;my %mips_dis;
while(<GFF>){
    chomp; 
    my ($chr,$stt,$end,$strand,$id,$cov_c,$meth,$tol_c)=(split(/\t/,$_))[0,1,2,3,4,6,7,8];
    next if (!$tol_c || $cov_c/($tol_c+0.00000001)<0.3 || $cov_c<10);
#    my ($chr,$stt,$end,$strand)=(split)[0,3,4,6];
    next if $chr!~/\d+/;
    my ($flag1,$pos1,$flag2,$pos2,$dis)=(0,1,0,$geno_len{$chr},0);
#    my $mid=int (($stt+$end)/2);
    for(my $i=$stt;$i>0;--$i){
       if(exists $fiv{"chr$chr\t$i"}){
           $flag1=5;
           $pos1=$fiv{"chr$chr\t$i"};
           last;
       }
       if(exists $thr{"chr$chr\t$i"}){
           $flag1=3;
           $pos1=$thr{"chr$chr\t$i"};
           last;
       }
    } 
    for(my $i=$end;$i<=$geno_len{$chr};++$i){
       if(exists $fiv{"chr$chr\t$i"}){
           $flag2=5;
           $pos2=$fiv{"chr$chr\t$i"};
           last;
       }
       if(exists $thr{"chr$chr\t$i"}){
           $flag2=3;
           $pos2=$thr{"chr$chr\t$i"};
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
#    print "$chr\t$stt\t$end\t$strand\t$dis\n";
    print "$chr\t$stt\t$end\t$strand\t$id\t$cov_c\t$meth\t$tol_c\t$dis\n"; 
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Gene position> <Genome length> <TE gff>
DIE
}
