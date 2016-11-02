#!/usr/bin/perl -w
use strict;
my ($imp,$dmr,$genepos,$out)=@ARGV;
die usage() unless @ARGV==4;
open POS,$genepos or die "$!";
my %pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    $chr="chr".$chr;
    @{$pos{$gene}}=($chr,$stt,$end,$strand);
}
open DMR,$dmr or die "$!";
my %dmr_mid;my %dmr_left;my %dmr_right;
<DMR>;
while(<DMR>){
    my ($chr,$stt,$end)=(split)[0,1,2];
    my $mid=int (($end+$stt)/2);
    @{$dmr_mid{"$chr\t$mid"}}=($stt,$end);
#    @{$dmr_left{"$chr\t$stt"}}=($stt,$end);
#    @{$dmr_right{"$chr\t$end"}}=($stt,$end);
}
open OUT,"+>$out" or die "$!";
my ($gene_region,$dmr_region)=(0,0);
my $n;
open IMP,$imp or die "$!";
my %imp;
while(<IMP>){
     chomp;
     my ($gene)=split;
     $imp{$gene}++;
}
open IMP,$imp or die "$!";
while(<IMP>){
    chomp;
    my ($gene)=(split)[0];
    my ($chr,$stt,$end,$strand)=(0,0,0,"NA");
    if($gene=~/chr/){
         ($chr,$stt,$end)=(split(/_/,$gene))[1,2,3]; 
    }else{
         ($chr,$stt,$end,$strand)=@{$pos{$gene}};
    }
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        my ($dmr_stt,$dmr_end)=(0,0,0);
        if(exists $dmr_mid{"$chr\t$i"}){
               ($dmr_stt,$dmr_end)=@{$dmr_mid{"$chr\t$i"}} if exists $dmr_mid{"$chr\t$i"}; 
            print OUT "$chr\t$stt\t$end\t$_\t$strand\t$dmr_stt\t$dmr_end\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <IMP> <DMR> <gene position> <OUT>
DIE
}
