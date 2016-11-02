#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($sam1, $sam2, $dmr) = @ARGV;
my %meth_in1;
open SAM1, $sam1 or die "$!";
while(<SAM1>){
    chomp;
    my ($chr,$pos,$c_num,$t_num) = split;
    push @{$meth_in1{"$chr\t$pos"}},($c_num, $t_num);
}
close SAM1;

open SAM2, $sam2 or die "$!";
my %meth_in2;
while(<SAM2>){
    chomp;
    my ($chr,$pos,$c_num,$t_num) = split;
    push @{$meth_in2{"$chr\t$pos"}},($c_num, $t_num);
}
close SAM2;

open DMR,$dmr or die "$!";
while(<DMR>){
    chomp;
    next if /#/;
    my ($chr, $stt, $end) = split;
    my ($c_num1,$t_num1, $c_num2,$t_num2)= (0,0,0,0);
    for(my $i = $stt; $i <=$end; ++$i){
        if(exists $meth_in1{"$chr\t$i"}){
            $c_num1 += ${$meth_in1{"$chr\t$i"}}[0];
            $t_num1 += ${$meth_in1{"$chr\t$i"}}[1];
        }
        if(exists $meth_in2{"$chr\t$i"}){
            $c_num2 += ${$meth_in2{"$chr\t$i"}}[0];
            $t_num2 += ${$meth_in2{"$chr\t$i"}}[1];
        }
    }
    next if ( $c_num1 + $t_num1 == 0 || $c_num2 + $t_num2 == 0);
    my $meth_lev1 = $c_num1 / ($c_num1 + $t_num1);
    my $meth_lev2 = $c_num2 / ($c_num2 + $t_num2);
    print "$chr\t$stt\t$end\t$c_num1\t$t_num1\t$c_num2\t$t_num2\t$meth_lev1\t$meth_lev2\n";
}
close DMR;

sub usage{
    my $die =<<DIE;
    perl *.pl <sample 1 > <sample 2> <DMR>
DIE
}


