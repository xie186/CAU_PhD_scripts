#!/usr/bin/perl -w
use strict;
my ($blat_res,$gene_pos,$subgeno)=@ARGV;
die usage() unless @ARGV==3;

open POS,$gene_pos or die "$!";
my %hash_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene)=split;
    $hash_pos{$gene}="$chr\t$stt\t$end";
}

open BLAT,$blat_res or die "$!";
my %hash_name;
my %hash_hit;
while(<BLAT>){
    chomp;
    my ($gene1,$gene2,$e_value)=(split)[0,1,-2];
    ($gene1)=split(/_/,$gene1) if $gene1=~/^GRM/;
    ($gene2)=split(/_/,$gene2) if $gene2=~/^GRM/;
    $hash_name{$gene1}++;    # record all FGS genes 
    next if $e_value>=0.1;
    $hash_hit{$gene1}++ if $gene1 ne $gene2;  # record genes has a blat hit 
}

open SUB,$subgeno or die "$!";
my %hash_sub;
while(<SUB>){
    chomp;
    my ($chr,$stt,$end,$sub)=split;
    $hash_sub{"$chr\t$stt\t$end"}=$sub;
}

foreach(keys %hash_name){
    next if exists $hash_hit{$_};
    $_=~s/FGP/FG/;
    my ($chr,$stt,$end)=split(/\t/,$hash_pos{$_});
    next if ($chr=~/^Mt/ || $chr=~/^Pt/ || $chr=~/^UNK/);
    my $flag=0;
    foreach my $sub_pos (keys %hash_sub){
        chomp;
        my ($chr_sub,$stt_sub,$end_sub)=split(/\t/,$sub_pos);
        if($chr_sub == $chr && $stt>=$stt_sub && $end<=$end_sub){
            $flag=$hash_sub{$sub_pos};
        }
    }
    print "$_\t$flag\n";
}

sub usage{
    my $die=<<DIE;
\n    perl *.pl <Blast search [All-again-all search]> <Gene position> <Maize subgenome>
    To identify single copy genes.
\n
DIE
}
