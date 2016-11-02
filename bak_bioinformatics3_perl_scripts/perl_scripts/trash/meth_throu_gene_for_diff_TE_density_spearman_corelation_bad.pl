#!/usr/bin/perl -w
use strict;
die "\n",usage(),"\n" unless @ARGV==4;
my ($repeat,$pos,$methor,$out)=@ARGV;

open OUT,"+>$out" or die;
my $start_time=localtime();
open REP,$repeat or die "$!";
my %hash;
while(<REP>){
    chomp;
    my ($chr,$stt,$end,$strand,$mips,$sec_mips,$number,$meth_pro)=split(/\t/);
    my $mid=int (($stt+$end)/2);
    if($methor eq "meth"){
        next if $meth_pro<10;
    }elsif($methor eq "unmeth"){
        next if $meth_pro>=10;
    }else{
        
    }
    $hash{"$chr\t$mid"}=$meth_pro;
}

open POS,$pos or die;
my %promoter;my %prom_exp;my %termina;my %ter_exp;my %intragenic;my %intra_exp;my $flag=1;
while(my $line=<POS>){
    print "$flag have been done\n" if $flag%1000==0;$flag++;
    chomp $line;
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank)=split(/\s+/,$line);
    foreach(my $i=$stt-1999;$i<=$end+1999;++$i){
        if(exists $hash{"$chr\t$i"}){
            &cal($name,$chr,$stt,$end,$strand,$rpkm,$rank,$i,$hash{"$chr\t$i"});
        }
    }
}
%hash=();

sub cal{
    my ($name,$chr,$stt,$end,$strand,$rpkm,$rank,$pos1,$lev)=@_;
    my ($meth,$report)=(0,0);
    my $key=0;
    my $unit=($end-$stt)/100;
    if($strand eq '+'){
        if($pos1<$stt){
            $key=int(($pos1-$stt)/100);
            push (@{$promoter{$key}},$meth);
            push (@{$prom_exp{$key}},$rpkm);
        }elsif($pos1>=$stt && $pos1<$end){
            $key=int (($pos1-$stt)/$unit);
            push(@{$intragenic{$key}},$meth);
            push(@{$intra_exp{$key}},$rpkm);
        }else{
            $key=int(($pos1-$end)/100);
            push (@{$termina{$key}},$meth);
            push (@{$ter_exp{$key}},$rpkm);
        }
    }else{
        if($pos1<=$stt){
            $key=int(($stt-$pos1)/100);
            push (@{$termina{$key}},$meth);
            push (@{$ter_exp{$key}},$rpkm);
        }elsif($pos1>$stt && $pos1<=$end){
            $key=int (($end-$pos1)/$unit);
            push(@{$intragenic{$key}},$meth);
            push(@{$intra_exp{$key}},$rpkm);
        }else{
            $key=int(($end-$pos1)/100);
            push (@{$promoter{$key}},$meth);
            push (@{$prom_exp{$key}},$rpkm);
        }
    }
}
sub usage{
    my $die=<<DIE;
    perl *.pl <Repeats> <Gene with expression Rank> <meth or unmeth or total> <OUTPUT>
    To get the correlation between each bins and methylation
DIE
}
