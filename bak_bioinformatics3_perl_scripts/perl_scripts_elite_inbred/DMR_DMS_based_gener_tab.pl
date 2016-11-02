#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dmr,$context)  = @ARGV;
my @dmr = split(/,/, $dmr);
my @context = split(/,/, $context);
for(my $i = 0; $i < @dmr; ++$i){
    open DMR, $dmr[$i] or die "$!";
    my @dmr_len;
    my ($hyper, $hypo) = (0,0);
    while(<DMR>){
        chomp;
        my ($chr,$stt,$end,$tis1,$tis2, $jug) = split;  
        push @dmr_len, ($end - $stt +1);
        if(/hyper/){
            ++$hyper;
        }else{
            ++$hypo;
        }
    }
    my $tot = $hyper + $hypo;
    my $median = &median(@dmr_len);
    print "$context[$i]\t$tot\t$median\t$hypo\t$hyper\n";
}

sub median{
    my @vals = sort {$a <=> $b} @_;
    my $len = @vals;
    if($len%2){ #odd?
        return $vals[int($len/2)];
    }else{ #even
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}

sub usage{
    my $die = <<DIE;
    perl *.pl <DMR [8112-478, 5003-478]> <context [8112-478, 5003-478]>  
DIE
}
