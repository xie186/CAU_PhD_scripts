#!/usr/bin/perl -w
use strict;
my ($gepos,$exp,$cutoff,$junc)=@ARGV;
die usage() unless @ARGV==4;
open POS,$gepos or die "$!";
my %hash;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
        $chr="chr".$chr;
    @{$hash{$gene}}=($chr,$stt,$end);
}
open JUNC,$junc or die "$!";  # bed file
my %junc;
while(<JUNC>){
    chomp;
    my ($chr,$stt,$end,$strand,$blk,$exon)=(split(/\s+/,$_))[0,1,2,5,10,11];
    my ($blk1,$blk2)=split(/,/,$blk);
       ($stt,$end)=($stt+$blk1+1,$end-$blk2+1);
    my $mid=int($stt+$end)/2;
    $junc{$mid}=$_;
}

open EXP,$exp or die "$!";
while(<EXP>){
    chomp;
    my ($gene,$exp_sd,$exp_endo)=split;
    next if ($exp_sd<$cutoff || $exp_endo<=$cutoff);
    my ($chr,$stt,$end)=@{$hash{$gene}};
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $junc{$i}){
            delete $junc{$i};
#            print "$junc{$i}\n";
        }
    }
    
}
foreach(keys %junc){
    print "$junc{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene position> <Expression> <Cutoff> <Junction in only one tissues>
DIE
}
