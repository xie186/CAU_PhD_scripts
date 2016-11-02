#!/usr/bin/perl -w
use strict;
my ($snp,$bismark,$b73,$mo17,$uncertain)=@ARGV;

die usage() unless @ARGV==5;
open SNP,$snp or die "$!";
my %snp;
while(<SNP>){
    chomp;
    my ($chr,$pos,$b_base,$mo_base)=split;
    next if ($b_base eq 'N' ||$mo_base eq 'N');
    next if(($b_base eq 'C' && $mo_base eq 'T') || ($b_base eq 'T' && $mo_base eq 'C') ||($b_base eq 'A' && $mo_base eq 'G') ||($b_base eq 'G' && $mo_base eq 'A'));   #  delete CT AG snp
    $snp{"$chr\t$pos"}=[$b_base,$mo_base];
}

open B,"+>$b73" or die "$!";
open MO,"+>$mo17" or die "$!";
open UN,"+>$uncertain" or die "$!";
open BIS,$bismark or die "$!";
my $bis_version=<BIS>;
print B "$bis_version";
print MO "$bis_version";
print UN "$bis_version";
my %hash;
while(<BIS>){
    my ($strand,$chr,$stt,$end,$pair1,$ref1,$pair2,$ref2)=(split(/\s+/,$_))[1,2,3,4,5,6,8,9];
    if($strand eq "+"){
        &ctct_pair1($chr,$stt,$end,$pair1,$ref1);
        &ctct_pair2($chr,$stt,$end,$pair2,$ref2);        
    }else{
        &ctga_pair1($chr,$stt,$end,$pair1,$ref1);
        &ctga_pair2($chr,$stt,$end,$pair2,$ref2);
    }
    if(exists $hash{"M"} && exists $hash{"B"}){
        print UN "$_";
    }elsif(exists $hash{"B"} && !exists $hash{"M"}){
        print B "$_";
    }elsif(!exists $hash{"B"} && exists $hash{"M"}){
        print MO "$_";
    }
    %hash=();
}

sub ctct_pair1{
    my ($chr,$stt,$end,$pair,$ref)=@_;
    my @pair=split(//,$pair);
    my @ref=split(//,$ref);
    for(my $i=0;$i<@pair;++$i){
        my $pos=$stt+$i;
        if(exists $snp{"$chr\t$pos"}){
            print "xxx:nonononon~!!!" if $ref[$i] ne ${$snp{"$chr\t$pos"}}[0];
            &jug($pair[$i],$ref[$i],${$snp{"$chr\t$pos"}}[0],${$snp{"$chr\t$pos"}}[1]);
        }
    }
}

sub ctct_pair2{
    my ($chr,$stt,$end,$pair,$ref)=@_;
    $pair=~tr/ATGC/TACG/;
    $ref=~tr/ATGC/TACG/;
    my @pair=split(//,$pair);
    my @ref=split(//,$ref);shift @ref;shift @ref;
    for(my $i=0;$i<@pair;++$i){
        my $pos=$end-$i;
        if(exists $snp{"$chr\t$pos"}){
            print "xxx:nonononon~!!!" if $ref[$i] ne ${$snp{"$chr\t$pos"}}[0];
            &jug($pair[$i],$ref[$i],${$snp{"$chr\t$pos"}}[0],${$snp{"$chr\t$pos"}}[1]);
        }
    }
}
sub ctga_pair1{
    my ($chr,$stt,$end,$pair,$ref)=@_;
    $pair=~tr/ATGC/TACG/;
    $ref=~tr/ATGC/TACG/;
    my @pair=split(//,$pair);
    my @ref=split(//,$ref);           # no shift here
    for(my $i=0;$i<@pair;++$i){
        my $pos=$end-$i;
        if(exists $snp{"$chr\t$pos"}){
            print "xxx:nonononon~!!!" if $ref[$i] ne ${$snp{"$chr\t$pos"}}[0];
            &jug($pair[$i],$ref[$i],${$snp{"$chr\t$pos"}}[0],${$snp{"$chr\t$pos"}}[1]);
        }
    }
}

sub ctga_pair2{
    my ($chr,$stt,$end,$pair,$ref)=@_;
    my @pair=split(//,$pair);   
    my @ref=split(//,$ref);    shift @ref;shift @ref;
    for(my $i=0;$i<@pair;++$i){
        my $pos=$stt+$i;
        if(exists $snp{"$chr\t$pos"}){
            print "xxx:nonononon~!!!" if $ref[$i] ne ${$snp{"$chr\t$pos"}}[0];
            &jug($pair[$i],$ref[$i],${$snp{"$chr\t$pos"}}[0],${$snp{"$chr\t$pos"}}[1]);
        }
    }
}
sub jug{
    my ($seq_base,$ref_base,$b_base,$mo_base)=@_;
    my $snp_join=join('',sort($b_base,$mo_base));
    if($snp_join eq 'AT'){                           
        if($seq_base eq $ref_base){
            $hash{"B"}++;
        }else{
            $hash{"M"}++;
        }
    }elsif($snp_join eq 'AC'){
        if(($seq_base ne $ref_base)&& ($seq_base ne 'T')){
            $hash{"M"}++;
        }else{
            $hash{"B"}++;
        }
    }elsif($snp_join eq 'TG'){
        if(($seq_base ne $ref_base)&& ($seq_base ne 'A')){
            $hash{"M"}++;
        }else{
            $hash{"B"}++;
        }
    }elsif($snp_join eq 'CG'){
        if($b_base eq 'C' && $mo_base eq 'G'){
            if($seq_base eq 'G' ||$seq_base eq 'A'){
                $hash{"M"}++;
            }else{
                $hash{"B"}++;
            }
        }else{
            if($seq_base eq 'C' ||$seq_base eq 'T'){
                $hash{"M"}++;
            }else{
                $hash{"B"}++;
            }
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <SNP> <Bismark> <B73 bis> <Mo17 bis> <Uncertaion>
DIE
}
