#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($fpkm, $out)  = @ARGV;
open FPKM, "$fpkm" or die "$!";
open OUT, "+>$out" or die "$!";
my $header = <FPKM>;
chomp $header;
print OUT "$header\tshannon_entropy\n";
while(my $line = <FPKM>){
    chomp $line;
    my ($gene,@fpkm) = split(/\t/,$line);
    my $jug_fpkm1 = 0;
    my $sum = 0;
    for(my $i = 0; $i < @fpkm;++$i){
        if($fpkm[$i] >=1){
            ++ $jug_fpkm1;
        }
        $sum += $fpkm[$i];
    }
    next if $jug_fpkm1 ==0;
    my $shannon = 0;
    for(my $i = 0; $i < @fpkm;++$i){
        if($fpkm [$i] == 0){
            $shannon+=0;
        }else{
	    my $p = $fpkm [$i]/$sum;
            my $my_shannon=-((log($p))*$p/(log 2));
            $shannon+=$my_shannon;
        }
    }
    print OUT "$line\t$shannon\n";

}

sub usage{
    my $die =<<DIE;
    perl *.pl <FPKM> <OUT> 
DIE
}
