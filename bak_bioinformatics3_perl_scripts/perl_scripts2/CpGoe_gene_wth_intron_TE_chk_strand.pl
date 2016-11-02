#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($TE_pos,$gff,$rpkm,$out)=@ARGV;
open POS,$TE_pos or die "$!";
my %hash;
my %hash_file;
while(<POS>){
    next if /#/;
    chomp;
    my ($chr,$stt,$end,$strand,$type)=(split)[0,1,2,3,4];
    my $mid=int (($stt+$end)/2);
    $hash{"$chr\t$mid"}=$type;
    $hash_file{"$chr\t$mid"}=$strand;
}


open RPKM,$rpkm or die "$!";
my %hash_rpkm;
while(<RPKM>){
    chomp;
    my ($gene,$tem_rpkm)=(split)[0,3];
    $hash_rpkm{$gene}=$tem_rpkm;
}
close RPKM;

open GFF,$gff or die "$!";
open OUT,"+>$out" or die "$!";
my %hash_intron;
my %hash_ele_nu;
my %hash_ele_len;
my %hash_wth_TE;
while(<GFF>){
    chomp;
    next if (/chromosome/ || /CDS/);
    my ($chr,$ele,$stt,$end,$strand,$name)=(split)[0,2,3,4,6,8];
    next if $ele!~/intron/;
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    
    next if !exists $hash_rpkm{$name};
    my $tem_rpkm=$hash_rpkm{$name};
    $hash_ele_nu{"$ele"}++;
    $hash_ele_len{"$ele"}+=($end-$stt+1);
    
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $hash{"$chr\t$i"}){
            my $TE_strand=$hash_file{"$chr\t$i"};
#            print OUT "$TE\t$join\t$tem_rpkm\n";
            my $type=$hash{"$chr\t$i"};
            print "$type\n";
            $hash_intron{"$ele\t$type"}++;
            $hash_wth_TE{$name}=$TE_strand;
        }
    }
}

open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp;
    my ($gene,$tem_rpkm)=(split)[0,3];
    my $wth_TE="NO";
    my $te_strd="NA";
    if(exists $hash_wth_TE{$gene}){
       $wth_TE="TE";
       $te_strd=$hash_wth_TE{$gene};
    }
    print OUT "$_\t$wth_TE\t$te_strd\n";
}
close RPKM;

foreach my $key(keys %hash_intron){
    my ($ele)=split(/\t/,$key);
    print "$key\t$hash_intron{$key}\t$hash_ele_nu{$ele}\t$hash_ele_len{$ele}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE position> <GFF> <FPKM> <OUT TE relate gene>
DIE
}
