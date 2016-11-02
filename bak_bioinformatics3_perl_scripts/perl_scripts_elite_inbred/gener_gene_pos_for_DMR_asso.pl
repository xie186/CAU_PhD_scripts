#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 7;
my ($gene_bed, $gene, $flank, $out_up,$out_down,$out_body,$out_genic) = @ARGV;
open BED,$gene_bed or die "$!";
my %gene_pos;
while(<BED>){
    chomp;
    my ($chr,$stt,$end,$name,$strand) = split;
    $gene_pos{$name} = $_;
}
close BED;

open OUTUP, "+>$out_up" or die "$!";
open OUTDOWN, "+>$out_down" or die "$!";
open OUTBODY, "+>$out_body" or die "$!";
open OUTGENIC, "+>$out_genic" or die "$!";
open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$name, $strand) = split(/\t/,$gene_pos{$_});
    if($strand eq "+"){
        my ($up_stt,$up_end) = ($stt - $flank, $stt-1);
            $up_stt = 0 if $up_stt <0;
        print OUTUP  "$chr\t$up_stt\t$up_end\t$name\t$strand\n";
        my ($down_stt,$down_end) = ($end +1, $end + $flank);
        print OUTDOWN "$chr\t$down_stt\t$down_end\t$name\t$strand\n";
    }else{  ## - 
        my ($up_stt,$up_end) = ($end +1, $end + $flank);
        print OUTUP  "$chr\t$up_stt\t$up_end\t$name\t$strand\n";
        my ($down_stt,$down_end) = ($stt - $flank, $stt-1);
           $down_stt = 0 if $down_stt < 0;
        print OUTDOWN "$chr\t$down_stt\t$down_end\t$name\t$strand\n";
    }
    print OUTBODY "$chr\t$stt\t$end\t$name\t$strand\n";    
    $stt -= $flank;
    $stt = 0 if $stt < 0;
    $end += $flank;
    print OUTGENIC "$chr\t$stt\t$end\t$name\t$strand\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <gene bed> <gene name> <flank> <out_up>  <out_down> <out_body> <out_genic>
DIE
}


