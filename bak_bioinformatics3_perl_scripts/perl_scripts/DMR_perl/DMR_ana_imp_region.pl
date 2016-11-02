#!/usr/bin/perl -w
use strict;
my ($imp,$gene_pos,$region)=@ARGV;
die usage() unless @ARGV==3;
open POS,$gene_pos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    $hash{$gene}=$_;
}

open IMP,$imp or die "$!";
my %total;
my %analyzed;
while(<IMP>){
    chomp;
    my ($chr,$stt,$end);
    if(/>IES/){
        ($chr,$stt,$end)=(split(/_/,$_))[1,2,3];
    }else{
        ($chr,$stt,$end)=(split(/\s+/,$hash{$_}))[0,1,2];
        $chr="chr".$chr;
    }
    for(my $i=$stt-2000;$i<=$end+2000;++$i){
        $total{"$chr\t$i"}++;
    }
}

open REGION,$region or die "$!";
while(<REGION>){
    chomp;
    my ($chr,$stt,$end)=split;
    for(my $i=$stt;$i<=$end;++$i){
        $analyzed{"$chr\t$end"}++ if exists $total{"$chr\t$end"}; 
    }
}
my $total=keys %total;
my $analyzed=keys %analyzed;
print "$analyzed\t$total\n";

sub usage{
    my $die=<<DIE;
    perl *.pl <Imprinted gene name> <Gene position WGS>  <Regions can be analyzed>
DIE
}
