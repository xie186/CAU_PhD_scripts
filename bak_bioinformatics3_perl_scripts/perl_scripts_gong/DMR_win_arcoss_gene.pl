#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($dmr_win, $ge_pos, $out)=@ARGV;
my $BIN = 60;

open WIN,$dmr_win or die "$!";
my %dmr_win;
while(<WIN>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end, $c_cover_alle1, $c_nu_alle1, $t_nu_alle1, $c_cover_alle2, $c_nu_alle2, $t_nu_alle2, $p_val, $adj_pval) = split;
    my ($meth_lev1, $meth_lev2) = ($c_nu_alle1/ ($c_nu_alle1 + $t_nu_alle1), $c_nu_alle2 / ($c_nu_alle2 + $t_nu_alle2));
    my $mid = int (($stt+$end)/2);
    if( $adj_pval < 0.01){
        if($meth_lev1 > $meth_lev2){
            $dmr_win{"$chr\t$mid"} = "hyper";
        }else{
            $dmr_win{"$chr\t$mid"} = "hypo";
        }
    }else{
        $dmr_win{"$chr\t$mid"} = "win";
    }
}

open OUT,"|sort -k2,2n -k3,3n >$out" or die;
open POS,$ge_pos or die "$!";
my %meth_forw;
my $flag=1;

while(my $line=<POS>){
        chomp $line;
        my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
        $chr="chr".$chr if $chr !~ /chr/;
        for(my $i = $stt - 1999;$i < $end+1999;++$i){
            if(exists $dmr_win{"$chr\t$i"}){
                &cal($stt, $end, $strand, $i, $dmr_win{"$chr\t$i"});
            }
        }
}

foreach(sort keys %meth_forw){
    ${$meth_forw{$_}}[1] =0 if !${$meth_forw{$_}}[1];
    ${$meth_forw{$_}}[0] =0 if !${$meth_forw{$_}}[0];
    my $meth_forwprint = ${$meth_forw{$_}}[1] / (${$meth_forw{$_}}[0] + ${$meth_forw{$_}}[1]);
    $_=~s/prom/-1/;
    $_=~s/body/0/;
    $_=~s/term/1/;
    print OUT "$_\t$meth_forwprint\n";
}
close OUT;

sub cal{
    my ($stt, $end, $strand, $pos1, $text) = @_;
    my $unit=($end-$stt+1)/($BIN - 0.01);
    my $keys=0;
    if($strand eq '+'){
        if($pos1<$stt){
            $keys=int(($pos1-$stt)/100);
            $keys="prom\t$keys";
        }elsif($pos1>=$stt && $pos1<$end){
            $keys=int (($pos1-$stt+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($pos1-$end)/100);
            $keys="term\t$keys";
        }
    }else{
        if($pos1<=$stt){
            $keys=int(($stt-$pos1)/100);
            $keys="term\t$keys";
        }elsif($pos1>$stt && $pos1<=$end){
            $keys=int (($end-$pos1+1)/$unit);
            $keys="body\t$keys";
        }else{
            $keys=int(($end-$pos1)/100);
            $keys="prom\t$keys";
        }
    }
    if($text eq "hyper"){
        ${$meth_forw{"hyper\t$keys"}}[1] ++;
    }elsif($text eq "hypo"){
        ${$meth_forw{"hypo\t$keys"}}[1] ++;
    }
    ${$meth_forw{"hyper\t$keys"}}[0] ++;
    ${$meth_forw{"hypo\t$keys"}}[0] ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <dmr windows> <Gene position GFF> <OUTPUT>
    This is to get the methylation distribution throughth gene
DIE
}
