#!/usr/bin/perl -w
use strict;
my ($dmr,$gff,$out)=@ARGV;
die usage() unless @ARGV==3;
open DMR,$dmr or die "$!";
my %dmr;
my %gene;
open OUT,"+>$out" or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$gene,$stt,$end)=(split)[0,3,5,6];
    my $mid=int (($stt+$end)/2);
    if($gene=~/IES/){
        my ($chr,$stt,$end)=split;
        if($mid<$stt ||$mid>$end){
            print OUT "$_\tintergenic\n";
        }else{
            print OUT "$_\tintragenic\n";
        }
    }
    @{$dmr{"$chr\t$mid"}}=($_,$gene);
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end,$xx)=(split)[0,2,3,4,-1];
    next if ($ele eq "chromosome" || $ele eq "gene" ||$ele eq "CDS" || $ele eq "mRNA");
    $chr="chr".$chr;
    if($_=~/\=AC/ ||$_=~/\=EF/ || $_=~/\=AY/ ||$_=~/\=AF/ ||$_=~/_T01/){
        for(my $i=$stt;$i<=$end;++$i){
            if(exists $dmr{"$chr\t$i"} && (my $find=index($_,${$dmr{"$chr\t$i"}}[1],0))>-1){
                my $dmr=${$dmr{"$chr\t$i"}}[0];
                print OUT "$dmr\t$ele\n";
            }
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <GFF first exon> <OUT>
DIE
}
