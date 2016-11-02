#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;

my %lap_siRNA;
my ($dmr, $tis,$header)  = @ARGV;
my @tis = split(/,/, $tis);
my %dmr_lap_siRNA;
for(my $i = 0; $i < @tis; ++$i){
    open TIS, $tis[$i] or die "$!";
    my %lap_siRNA;
    while(<TIS>){
        chomp;
        my ($chr,$stt,$end,$all_sites,$stab_sites,$chr1,$stt1) = split;
        if($stt1 == -1){
            $lap_siRNA{"$chr\t$stt\t$end"} = 0;
        }else{
            $lap_siRNA{"$chr\t$stt\t$end"} = 1;
        }
    }
    open DMR,$dmr or die "$!";
    while(<DMR>){
        chomp;
        my ($chr,$stt,$end) = split;
        push @{$dmr_lap_siRNA{"$chr\t$stt\t$end"}}, $lap_siRNA{"$chr\t$stt\t$end"};
    }
}

open DMS,$dmr or die "$!";
my $head = <DMS>;
chomp $head;
my ($CHR,$STT,$END,$ALL,$STAB,@METH_H) = split(/\t/, $head);
$header =~ s/,/\t/g;
my $METH_H = join("\t",@METH_H);
print "\t$METH_H\t$header\tall\tstab\n";
while(<DMS>){
    chomp;
    next if /Nan/;
    my ($chr, $stt, $end, $all, $stab, @meth_info) = split;
    my $stat_siRNA = join("\t", @{$dmr_lap_siRNA{"$chr\t$stt\t$end"}});
    my $meth_info = join("\t",@meth_info);
    print "$chr\_$stt\_$end\t$meth_info\t$stat_siRNA\t$all\t$stab\n";
}

sub usage{
    my $die = <<DIE;
    perl *.pl <dmr> <tissue [tis1,tis2,tis3]> <header [tis1,tis2,tis3]> 
DIE
}
