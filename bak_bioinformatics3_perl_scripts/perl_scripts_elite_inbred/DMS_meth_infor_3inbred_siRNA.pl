#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;

my %lap_siRNA;
my ($dms, $tis1,$tis2,$tis3,$header)  = @ARGV;
open TIS,$tis1 or die "$!";
while(<TIS>){
    chomp; 
    my ($chr,$stt,$end,$id,$chr1,$stt1) = split;
    if($stt1 == -1){
        $stt1 = 0;
    }else{
        $stt1 = 1;
    }
    push @{$lap_siRNA{"$chr\_$stt"}}, $stt1; 
}
close TIS;

open TIS,$tis2 or die "$!";
while(<TIS>){
    chomp;
    my ($chr,$stt,$end,$id,$chr1,$stt1) = split;
    if($stt1 == -1){
        $stt1 = 0;
    }else{
        $stt1 = 1;
    }
    push @{$lap_siRNA{"$chr\_$stt"}}, $stt1;
}
close TIS;

open TIS,$tis3 or die "$!";
while(<TIS>){
    chomp;
    my ($chr,$stt,$end,$id,$chr1,$stt1) = split;
    if($stt1 == -1){
        $stt1 = 0;
    }else{
        $stt1 = 1;
    }
    push @{$lap_siRNA{"$chr\_$stt"}}, $stt1;
}
close TIS;

open DMS,$dms or die "$!";
my $head = <DMS>;
chomp $head;
$header =~ s/,/\t/g;
print "$head\t$header\n";
while(<DMS>){
    chomp;
    my ($id,$lev1,$lev2,$lev3) = split;
    my $stat_siRNA = join("\t", @{$lap_siRNA{$id}});
    print "$_\t$stat_siRNA\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <dms> <tis1> <tis2> <tis3> <header> 
DIE
}
