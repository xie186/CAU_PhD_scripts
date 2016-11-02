#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 1;
my ($rpkm) = @ARGV;
open RPKM,$rpkm or die "$!";
while(<RPKM>){
    chomp; 
    my ($chr,$stt,$end,@rpkm) = split;
    my ($mean, $sd,@z_score) = &get_sd(@rpkm);
    my $z_score = join("\t",@z_score);
    print "$chr\t$stt\t$end\t$z_score\n";
}

sub get_sd{
    my @rpkm = @_;
    for(my $i = 0;$i < @rpkm;++ $i){
        $rpkm[$i] = log($rpkm[$i]+1)/log(2);
    }
    my $sum = 0;
    for(my $i = 0;$i<@rpkm;++$i){
        $sum += $rpkm[$i];
    }
    my $mean = $sum/@rpkm;
    my $sum_R = 0;
    for(my $i = 0;$i < @rpkm;++ $i){
        $sum_R += ($rpkm[$i] - $mean) ** 2;
    }
    my $sd = sqrt($sum_R/(@rpkm - 1));
    my @z_score;
    foreach (@rpkm){
        push (@z_score, ($_ - $mean)/($sd));
    }
    return ($mean, $sd, @z_score);
}

sub usage{
    print <<DIE;
    perl *.pl <> <> 
DIE
    exit 1;
}
