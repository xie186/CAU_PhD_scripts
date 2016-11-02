#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 5;

my %lap_siRNA;
my ($dmr, $tis,$header, $tis_cmp, $out)  = @ARGV;
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
open OUT1, "+>$out.1" or die "$!";
open OUT2, "+>$out.2" or die "$!";
open OUT3, "+>$out.3" or die "$!";
open OUT4, "+>$out.4" or die "$!";
print OUT1 "\t$METH_H\t$header\n";
print OUT2 "\t$METH_H\t$header\n";
print OUT3 "\t$METH_H\t$header\n";
print OUT4 "\t$METH_H\t$header\n";
while(<DMS>){
    chomp;
    next if /Nan/;
    my ($chr, $stt, $end, $all, $stab, @meth_info) = split;
    my $stat_siRNA = join("\t", @{$dmr_lap_siRNA{"$chr\t$stt\t$end"}});
    my $meth_info = join("\t",@meth_info);
    
    my $cmp = $meth_info[0];
    if($tis_cmp eq "5003"){
        $cmp = $meth_info[1];
    }
    if($cmp < $meth_info[2] && $stab/$all > 0.8){
        print OUT1 "$chr\_$stt\_$end\t$meth_info\t$stat_siRNA\n";
    }elsif($cmp < $meth_info[2] && $stab/$all < 0.2){
        print OUT2 "$chr\_$stt\_$end\t$meth_info\t$stat_siRNA\n";
    }elsif($cmp > $meth_info[2] && $stab/$all > 0.8){
        print OUT3 "$chr\_$stt\_$end\t$meth_info\t$stat_siRNA\n";
    }elsif($cmp > $meth_info[2] && $stab/$all < 0.2){
        print OUT4 "$chr\_$stt\_$end\t$meth_info\t$stat_siRNA\n";
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <dmr> <tissue [tis1,tis2,tis3]> <header [tis1,tis2,tis3]> <tis [8112, 5003]> <OUT>
DIE
}
