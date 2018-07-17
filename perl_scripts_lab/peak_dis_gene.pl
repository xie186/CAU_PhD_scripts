#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($coor, $peak, $out) = @ARGV;

my $BIN = 60;

print "Start recording depth information ", `date`;
my $flag1 = 1;
open PEAK, $peak or die "$!";
my %rec_peak_pos;
while(<PEAK>){
    chomp;
    print "$flag1 have processed\n" if $flag1 % 10000000 == 0;
    my ($chr, $stt,$end) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    $rec_peak_pos{"$chr\t$stt"} ++;
    ++$flag1;
}
close PEAK;

print "Start processing distribution ", `date`;
my $flag = 1;
my ($len_up, $len_body, $len_down) = (0, 0, 0);
my %rec_bin_dep;
open COOR,$coor or die "$!";
while(<COOR>){
    chomp;
    print "$flag have processed\n" if $flag % 500 == 0;
    my ($chr, $stt, $end, $id, $strand) = split;
    $chr = "chr".$chr if $chr !~ /chr/;
    $len_up += 1999;
    $len_body += $end - $stt + 1;
    $len_down += 1999;
    for(my $i = $stt - 1999;$i < $end+1999;++$i){
       if(exists $rec_peak_pos{"$chr\t$i"}){
           &cal($stt,$end,$strand,$i);
       }
    }
    ++$flag;
}
close COOR;

open OUT, "+>$out" or die "$!";
print "Start printing results\n";
foreach my $tem_key(sort keys %rec_bin_dep){
    my $len = $len_body/$BIN;
    if($tem_key =~ /prom/){
        $len = $len_up/20;
    }elsif($tem_key =~ /term/){
        $len = $len_down/20;
    }


    my $norm_dep = $rec_bin_dep{$tem_key} * 1000000/$len;
    $tem_key =~ s/prom/-1/;
    $tem_key =~ s/body/0/;
    $tem_key =~ s/term/1/;
    print OUT "$tem_key\t$norm_dep\n";
}
close OUT;

print <<REPORT;
Total Length:
$len_up\t$len_body\t$len_down
REPORT

sub cal{
    my ($stt,$end,$strand,$pos1) = @_;
    my $unit=($end-$stt+1)/($BIN - 0.01);
    my $keys="NA";
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
    $rec_bin_dep{$keys} ++;
    #$rec_bin_site{$keys} -> {$i} ++;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <coor> <peak> <out>
    This is to get the ChIP peak distribution throughth specific regions
DIE
}
