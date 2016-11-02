#!/usr/bin/perl -w
use strict;
my ($dmr,$gff)=@ARGV;
die usage() unless @ARGV==2;
open DMR,$dmr or die "$!";
my %dmr;
while(<DMR>){
    chomp;
    my ($chr,$stt,$end)=(split)[0,1,2];
    my $mid=int (($stt+$end)/2);
    $dmr{"$chr\t$mid"}=$_;
}

open GFF,$gff or die "$!";
while(<GFF>){
    chomp;
    my ($chr,$ele,$stt,$end)=(split)[0,2,3,4];
    $chr="chr".$chr;
    next if ($ele eq "chromosome" || $ele eq "gene" ||$ele eq "CDS" ||$ele eq "mRNA");
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr{"$chr\t$i"}){
            print "$dmr{\"$chr\t$i\"}\t$ele\n";
        }
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <GFF first exon>
DIE
}
