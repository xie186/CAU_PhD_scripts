#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($peak_snp,$gene_pos,$p_log_cut) = @ARGV;
open POS,$gene_pos or die "$!";
my %gene_pos;
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand) = split; 
    push @{$gene_pos{$chr}}, $_;
}

open PEAK,$peak_snp or die "$!";
while(<PEAK>){
    chomp;
    my ($chr,$pos,$maf,$p_log) = split;
    next if $p_log < $p_log_cut;
    my %dis;
    foreach my $tem_gene(@{$gene_pos{$chr}}){
        my ($chr,$stt,$end,$gene,$strand) = split(/\t/,$tem_gene);
        my $dis1 = $pos - $stt;
        my $dis2 = $pos - $end;
        if($dis1 < 0 && $dis2 < 0){
            $dis{$gene} = abs($dis1);
#            push @dis, abs($dis1);
        }elsif($dis1 > 0 && $dis2 > 0){
            $dis{$gene} = $dis2;
#            push @dis, $dis2;
        }else{
            $dis{$gene} = 0;
#            push @dis, 0;
        }
    }
    my @keys = sort {$dis{$a}<=>$dis{$b}} keys %dis;
    print "$_\t$keys[0]\t$dis{$keys[0]}\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <peak snp> <gene pos> <p _log cut>
DIE
}
