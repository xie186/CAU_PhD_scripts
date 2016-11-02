#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($dms, $other_two,$header, $out)  = @ARGV;
open DMS,$dms or die "$!";
my %dms_pos;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    next if $qval >= 0.01;
    push @{$dms_pos{"$chr\t$stt"}}, ($lev1,$lev2);
}

open TWO,$other_two or die "$!";
while(<TWO>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split;
    push @{$dms_pos{"$chr\t$stt"}}, ($lev1) if exists $dms_pos{"$chr\t$stt"};
}

$header =~ s/,/\t/g;
open OUT,"+>$out" or die "$!";
print OUT "\t$header\n";
foreach(keys %dms_pos){
    my @meth_lev = @{$dms_pos{$_}};
    my $num = @meth_lev;
    my $meth_lev = join("\t",@meth_lev);
    if($num == 3){
        $_ =~ s/\t/_/;
        print OUT "$_\t$meth_lev\n";
        my ($chr,$pos) = split(/_/,$_);
        my $end = $pos + 1;
        print "$chr\t$pos\t$end\t$_\n";
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <dms> <other_two> <header [8112,478,5003,Zheng58]  OUT 
DIE
}
