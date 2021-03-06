#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 2;
my ($dmr_pos, $all_ana)=@ARGV;

open ANA,$all_ana or die "$!";
my @all_ana_reg;
while(<ANA>){
    chomp;
    my ($chr,$stt,$end,$all_sites) = split;
    next if $all_sites < 5;
    push @all_ana_reg, $_;
}
close ANA;

my @dmr_line;
open DMR,$dmr_pos or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end,$all_sites,$context) = split;
    next if $all_sites < 5;
    push @dmr_line, "$chr\t$stt\t$end\t$context\n";
    print "$chr\t$stt\t$end\t$context\n";
}

my $all_reg_num = @all_ana_reg;
for(my $i = 0; $i < @dmr_line; ++$i){
    my ($chr,$stt,$end) = split(/\t/,$dmr_line[$i]);
    my $line_num = int(rand($all_reg_num));
    my ($chr_tem,$stt_tem,$end_tem,$all_sites_tem) = split(/\t/,$all_ana_reg[$line_num]);
    my $tem_stt = int(($stt_tem + $end_tem + 1)/2 - ($end - $stt + 1)/2);
       $tem_stt = 0 if $tem_stt < 0;
    my $tem_end = $tem_stt + $end-$stt+1;
    print "$chr_tem\t$tem_stt\t$tem_end\trandom\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMR> <all regions analysed>
    This is to get the regions of DMS cluster and randomly selected analysable regions
DIE
}
