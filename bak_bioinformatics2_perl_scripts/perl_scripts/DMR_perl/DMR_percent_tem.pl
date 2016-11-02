#!/usr/bin/perl -w
use strict;
my ($imp,$genepos,$dmr)=@ARGV;
die usage() unless @ARGV==3;
open DMR,$dmr or die "$!";
my %dmr;
while(<DMR>){
    chomp;
    my ($chr,$stt,$end)=split;
    my $mid=int (($stt+$end)/2);
    @{$dmr{"$chr\t$mid"}}=($stt,$end);
}

open POS,$genepos or die "$!";
my %pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    $chr="chr".$chr;
    @{$pos{$gene}}=($chr,$stt,$end);
}

open IMP,$imp or die "$!";
my %ana;
my ($ge_region,$dmr_region)=(0,0);
while(<IMP>){
    chomp;
    my ($gene)=split;
    my ($chr,$stt,$end);
    if($gene=~/^>IES/){
        ($chr,$stt,$end)=(split(/_/,$gene))[1,2,3];
    }else{
        ($chr,$stt,$end)=@{$pos{$gene}};
    }
    $ge_region+=$end-$stt+4000;
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        if(exists $dmr{"$chr\t$i"}){       
            $ana{$gene}++;
            $dmr_region+=${$dmr{"$chr\t$i"}}[1]-${$dmr{"$chr\t$i"}}[0];
        }
    }
}
close IMP;

my $nu=keys %ana;
my $perc=$dmr_region/$ge_region;
print "Number of  imprinted gene that we can analize is :$nu\nPercentage of regions where methylation level can be determined:$dmr_region\t$ge_region\t$perc\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <IMP> <Genepos> <Regions that canbe determined>
DIE
}
