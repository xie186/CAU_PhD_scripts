#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($ge_pos,$geno_len,$cgi)=@ARGV;
open POS,$ge_pos or die "$!";
my %fiv;my %thr;
while(<POS>){
    chomp;
    my ($chr,$stt,$end)=split;
    $fiv{"chr$chr\t$stt"}=$stt;
    $thr{"chr$chr\t$end"}=$end;
}
open LEN,$geno_len or die "$!";
my %geno_len;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $geno_len{$chr}=$len;
}
open GFF,$cgi or die "$!";
my %mips_nu;my %mips_dis;
while(<GFF>){
    chomp; 
    my ($chr,$stt,$end)=(split(/\s+/,$_))[0,1,2];
    my ($flag1,$pos1,$flag2,$pos2,$dis)=(0,1,0,$geno_len{$chr},0);
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
    if($flag1==5 && $flag2==3){
        $dis=0;
    }else{
        my ($len1,$len2)=($stt-$pos1+1,$pos2-$end+1);
        my @aa=sort{$a<=>$b}($len1,$len2);
        $dis=$aa[0];
    }
    print "$_\t$dis\n";
 
}
sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Gene position> <Genome length> <CGI position>
DIE
}
