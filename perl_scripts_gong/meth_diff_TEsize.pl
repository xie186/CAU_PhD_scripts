#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 4;
my ($bed_OT, $bed_OB, $TE_pos, $out)=@ARGV;

my %meth_pos;
$bed_OT = "zcat $bed_OT|" if $bed_OT =~ /gz$/;
open BED,$bed_OT or die "$!";
while(<BED>){
    chomp;
    my ($chrom,$pos1,$pos2, $depth, $lev) = split;
        $chrom =~ s/Chr/chr/g;
    next if ($depth < 4 || $depth > 100);
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
close BED;
print "Reading $bed_OT: Done\n";

$bed_OB = "zcat $bed_OB|" if $bed_OB =~ /gz$/;
open BED,$bed_OB or die "$!";
while(<BED>){
    chomp;
    my ($chrom,$pos1,$pos2, $depth, $lev) = split;
        $chrom =~ s/Chr/chr/g;
    next if ($depth < 4 || $depth > 100);
    my $c_num = int ($depth*$lev/100 + 0.5);
    my $t_num = $depth - $c_num;
    @{$meth_pos{"$chrom\t$pos1"}} = ($c_num, $t_num);
}
close BED;
print "Reading $bed_OB: Done\n";

open OUT,"|sort -k1,1n -k2,2n >$out" or die;
open POS,$TE_pos or die "$!";
my %meth_bin;
my $flag=1;

while(my $line=<POS>){
    chomp $line;
    my ($chr, $stt, $end, $name, $strand)=split(/\t/,$line);
    $chr="chr".$chr if $chr !~ /chr/;
    my $len = $end - $stt + 1;
    if($len >= 6000){
        $len = 5999;
    }
    my $bin = int ($len/50 + 1);  ## 50 bp windows
    my $count = 0;
    my $sum_c_num = 0;
    my $sum_t_num = 0;
    for(my $i = $stt;$i < $end;++$i){
            if(exists $meth_pos{"$chr\t$i"}){
                ++ $count;
                $sum_c_num += ${$meth_pos{"$chr\t$i"}}[0];
                $sum_t_num += ${$meth_pos{"$chr\t$i"}}[1];
            }
    }
    if($count * 200/($end - $stt + 1) >= 5 ){
        ${$meth_bin{$bin}}[0] += $sum_c_num;
        ${$meth_bin{$bin}}[1] += $sum_t_num;
    }
}

foreach(sort keys %meth_bin){
    my $meth_bin = ${$meth_bin{$_}}[0] / (${$meth_bin{$_}}[0] + ${$meth_bin{$_}}[1]);
    print OUT "$_\t$meth_bin\n";
}
close OUT;

sub usage{
    my $die=<<DIE;
    perl *.pl <bed OT> <bed OB> <TE position> <OUTPUT>
    This is to get the methylation level of different size of TEs.
DIE
}
