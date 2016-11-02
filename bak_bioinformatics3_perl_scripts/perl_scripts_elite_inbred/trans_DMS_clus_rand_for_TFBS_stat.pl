#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($region,$nucleo, $out) = @ARGV;

print "reading $nucleo !\n";
open NUCLEO, $nucleo or die "$!";
my %TFBS_stat;
while(<NUCLEO>){
    my ($chr, $stt, $end) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    for(my $i = $stt; $i < $end; ++$i){
	$TFBS_stat{"$chr\t$i"} ++;
    }
}
close NUCLEO;
print "Done reading $nucleo !\n";

my %reg_pos;
open REG,$region or die "$!";
print "reading $region !\n";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$context) = split;
    my $mid = int(($stt + $end)/2);
    for(my $i = -2000;$i <= 1999;++$i){
        my $pos = $mid + $i;
        ${$reg_pos{"$context\t$i"}}[0] ++;
        if(exists $TFBS_stat{"$chr\t$pos"}){
            ${$reg_pos{"$context\t$i"}}[1] ++;
        }
    }
}
close REG;
print "Done reading $region !\n";

open OUT, "|sort -k1,1 -k2,2n > $out" or die "$!";
foreach(keys %reg_pos){
    my $aver_occu = ${$reg_pos{$_}}[1] *1000 / ${$reg_pos{$_}}[0];
    print OUT "$_\t$aver_occu\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <nucleo> <out>
DIE
}

