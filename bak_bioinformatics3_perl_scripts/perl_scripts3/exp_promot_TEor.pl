#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($TE_pos,$gff,$ge_pos,$out)=@ARGV;
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
    next if $ele!~/upstream/;
    ($name)=(split(/=/,(split(/;/,$name))[0]))[1];
    $name=~s/_T\d+// if $name=~/GRMZM/;
    my @aa=split;
    $aa[-1]=$name;
    my $join=join("\t",@aa);
    $hash_ele_nu{"$ele"}++;
    $hash_ele_len{"$ele"}+=($end-$stt+1);
    
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $hash{"$chr\t$i"}){
            my $TE_strand=$hash_file{"$chr\t$i"};
#            print OUT "$TE\t$join\t$tem_rpkm\n";
            my $type=$hash{"$chr\t$i"};
            $hash_intron{"$ele\t$type"}++;
            $hash_wth_TE{$name}=$TE_strand;
        }
    }
}

open GEPOS,$ge_pos or die "$!";
while(<GEPOS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand)=split;
    my $wth_TE="NO";
       $wth_TE="TE" if exists $hash_wth_TE{$gene};
    print OUT "$_\t$wth_TE\n";
}
close GEPOS;

foreach my $key(keys %hash_intron){
    my ($ele)=split(/\t/,$key);
    print "$key\t$hash_intron{$key}\t$hash_ele_nu{$ele}\t$hash_ele_len{$ele}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE position> <GFF> <Geneposition [WGS][FGS]> <OUT TE relate gene>
DIE
}
