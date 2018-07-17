#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;
my ($bed_OT, $bed_OB, $ge_pos, $flank,$out)=@ARGV;
my $BIN = 100;
my $num = $flank/ $BIN;

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

my %stat_meth;
open OUT,"|sort -k1,1n >$out" or die;
open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $mid = int (($stt+$end)/2);
    for(my $i = -1; $i >= -$num; --$i ){
        my ($tem_stt, $tem_end) = ($mid + $BIN*$i, $mid + $BIN*($i+1) );
        &stat_CT($chr, $tem_stt,$tem_end, $i);
    }
    for(my $i = 0; $i < $num; ++$i ){
        my ($tem_stt, $tem_end) = ($mid + $BIN*$i, $mid + $BIN*($i+1) );
        &stat_CT($chr, $tem_stt,$tem_end, $i);
    }
}

foreach(keys %stat_meth){
    print OUT "$_\t${$stat_meth{$_}}[0]\t${$stat_meth{$_}}[1]\n";
}

sub stat_CT{
    my ($chr,$stt, $end, $index) = @_;
    for(my $i = $stt; $i < $end; ++$i){
        if(exists $meth_pos{"$chr\t$i"}){
           ${$stat_meth{$index}}[0] += ${$meth_pos{"$chr\t$i"}}[0];
           ${$stat_meth{$index}}[1] += ${$meth_pos{"$chr\t$i"}}[1];
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <OT> <OB>  <region> <flank regions> <OUT>
DIE
}
