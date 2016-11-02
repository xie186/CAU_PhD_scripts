#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV ==3;
my ($hyper_geno1,$hypo_geno2,$process) = @ARGV;
open GENO1,$hyper_geno1 or die "$!";
my %hash_tot_pos1;
my %hash_lap_pos1;
while(<GENO1>){
    #chr4    227273747       227273747       0       20      9       2       0       0.818181818181818       -0.818181818181818      2.72816445375327e-06    0.0005710752    N       .       -1      -1      .       0
    my ($chr,$stt,$lap) = (split)[0,1,-4];
    $hash_tot_pos1{"$chr\t$stt"} ++;
    if($lap != -1){
        $hash_lap_pos1{"$chr\t$stt"} ++;
    }
}
close GENO1;

open GENO2,$hypo_geno2 or die "$!";
my %hash_tot_pos2;
my %hash_lap_pos2;
while(<GENO2>){
    my ($chr,$stt,$lap) = (split)[0,1,-4];
    $hash_tot_pos2{"$chr\t$stt"} ++;
    if($lap != -1){
        $hash_lap_pos2{"$chr\t$stt"} ++;
    }
}
close GENO2;

my $tot1 = keys %hash_tot_pos1;
my $lap_num1 = keys %hash_lap_pos1;
my $tot2 = keys %hash_tot_pos2;
my $lap_num2 = keys %hash_lap_pos2;
my ($lapno_num1) = $tot1 - $lap_num1;
my ($lapno_num2) = $tot2 - $lap_num2;
#my $perc1 = sprintf("%.3f", $lap_num1 / $tot1);
#my $perc2 = sprintf("%.3f", $lap_num2 / $tot2);
#$new_var = sprintf("%.3f", $var);
my $perc1 = &float2pct($lap_num1 / $tot1);
my $perc2 = &float2pct($lap_num2 / $tot2);
my $p_value = &chisq($lap_num1, $lap_num2, $lapno_num1, $lapno_num2);
print <<OUT;
$process($tot1)	# of DMSs overlapped with 24nt cluster	# of DMSs not overlapped with 24nt cluster	P value
Hypermethylated genotype	$lap_num1($perc1)	$lapno_num1	$p_value
Hypomethylated genotype	$lap_num2($perc2)	$lapno_num2
OUT

sub chisq{
    my ($lap_num1, $lap_num2, $lapno_num1, $lapno_num2) = @_;
    open O,"+>$process.R" or die "$!";
    print O "rpkm<-c($lap_num1, $lap_num2, $lapno_num1, $lapno_num2)\ndim(rpkm)=c(2,2)\nchisq.test(rpkm)\$p.value\n";
    close O;
    my $report=`R --vanilla --slave < $process.R`;
    my $p_value=(split(/\s+/,$report))[1] ||0;
}

sub float2pct{
    my ($float) = @_;
    my $pct = (sprintf("%.4f",shift)*100)."%";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <hyper_geno1> <hypo_geno2> <process>
DIE
}

