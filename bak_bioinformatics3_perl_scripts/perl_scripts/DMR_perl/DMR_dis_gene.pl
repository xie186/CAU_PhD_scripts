#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==2;
my ($dmr,$gene)=@ARGV;
open DMR,$dmr or die "$!";
my %dmr_hash;
while(<DMR>){
    chomp;
    my ($chr,$stt,$end)=split;
    my $mid=(int ($stt+$end)/2)+1;
       $dmr_hash{"$chr\t$mid"}++;
}

open GENE,$gene or die "$!";
my %hash;
while(<GENE>){
    chomp;
    my ($chr,$ele,$stt,$end)=(split)[0,2,3,4];
    next if ($ele=~/chromosome/ || $ele=~/mRNA/ ||$ele=~/CDS/);
        $chr="chr".$chr;
    for(my $i=$stt;$i<=$end;++$i){
        if(exists $dmr_hash{"$chr\t$i"}){
            $hash{$ele}++;
        }
    }
}
foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <Gene ele gff>
DIE
}
