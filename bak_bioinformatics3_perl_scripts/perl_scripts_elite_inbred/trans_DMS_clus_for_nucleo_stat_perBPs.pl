#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($region,$nucleo, $win_size ,$out) = @ARGV;
my %reg_pos;
open REG,$region or die "$!";
print "reading $region !\n";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$context) = split; 
    my $mid = int(($stt + $end)/2);
    for(my $i = $mid - $win_size;$i < $mid + $win_size -1; ++$i){
        my $rela_pos = $i - $mid;
        $reg_pos{"$chr\t$i"} = "$context";
    }
}
close REG;
print "Done reading $region !\n";

print "reading $nucleo !\n";
open NUCLEO, $nucleo or die "$!";
my %nucleo_stat;
while(<NUCLEO>){
    my ($chr, $pos, $p_start, $occup, $nl,  $affi) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    next if !exists $reg_pos{"$chr\t$pos"};
    my $context = $reg_pos{"$chr\t$pos"};
    ${$nucleo_stat{$context}}[1] += $occup;
    ${$nucleo_stat{$context}}[0] ++;
}
close NUCLEO;
print "Done reading $nucleo !\n";

open OUT, "|sort -k1,1 -k2,2n > $out" or die "$!";
foreach(keys %nucleo_stat){
    my $aver_occu = ${$nucleo_stat{$_}}[1] / ${$nucleo_stat{$_}}[0];
    print OUT "$_\t$aver_occu\n";
}
close OUT;

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <nucleo> <win_size> <out> 
DIE
}
