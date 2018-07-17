#!/usr/bin/perl -w
use strict;
use Statistics::R ; # Module Version: 0.33   Source  

die usage() unless @ARGV ==4;
sub usage{
    my $die =<<DIE;
perl $0 <bed file> <depthcut [low,high]> <FDR cutoff> <output> 
DIE
}
my ($bed, $dep_cut ,$p_cut, $out) = @ARGV;

my $MAX = 100;
my $INIT_M = 1;

my ($dep_cut_low, $dep_cut_high) = split(/,/, $dep_cut);
my ($chloro_mc, $chloro_dep) = (0,0);
my %ana_sites;
open BED, $bed or die "$!";
while(<BED>){
    chomp;
    #chrC 122414  2 1645
    #chr pos mC unmethC
    next if /number_of_T/;
    my ($chr, $pos, $mc, $uc) = split;
    my $dep = $mc + $uc;
    next if ($dep > $dep_cut_high || $dep < $dep_cut_low);

    #stat the methylation information of chloroplast
    if($chr eq "chrC"){
        $chloro_mc += $mc;
        $chloro_dep += $dep;
    }
    if($chr =~ /chr\d+/){
        $ana_sites{"$chr,$pos,$mc,$dep"} = "NA";
    }
}
close BED;

my $err_rate = $chloro_mc/$chloro_dep;
my ($context) = $bed =~ /bed_(.*)_OT/;
print STDOUT <<OUT;
Starting to process CHG context
----Error rate = $err_rate
----Binomial probability table with error: $err_rate
----Cutoff with a 0.01 FDR
OUT

my $R = Statistics::R->new();
my $tot_mc = 0;
my $tot_sites = keys %ana_sites;
foreach my $coor(keys %ana_sites){
    my ($chr, $pos, $mc, $dep) = split(/,/, $coor);
    $R -> run("p_val<-binom.test($mc,$dep,$err_rate)\$p.value");
    my $p_val = $R ->get('p_val');
    #print "$chr\t$pos\t$mc\t$dep\t$p_val\n";
    $ana_sites{"$chr,$pos,$mc,$dep"} = $p_val;
    if($ana_sites{"$chr,$pos,$mc,$dep"} < $INIT_M){
        $tot_mc ++;
    }
}
$R->stop();
my $perc_mc = $tot_mc/$tot_sites;
print STDOUT "----Iteration 1: $INIT_M, %mC: $perc_mc\n";
$INIT_M = $p_cut * $perc_mc/(1-$perc_mc);

for(my $i = 2; $i <= $MAX; ++$i){
    $tot_mc = 0;
    foreach my $coor(keys %ana_sites){
        my ($chr, $pos, $mc, $dep) = split(/,/, $coor);
        if($ana_sites{"$chr,$pos,$mc,$dep"} < $INIT_M){
            $tot_mc ++;
        }
    }
    my $tem_perc_mc = $tot_mc/$tot_sites;
    print STDOUT "----Iteration $i: $INIT_M, %mC: $tem_perc_mc\n";
    $INIT_M = $p_cut * $tem_perc_mc/(1- $tem_perc_mc);
    if($tem_perc_mc - $perc_mc == 0){
        print STDOUT <<OUT;
----Update calls
----Performing final methylation call update with M = $INIT_M
----Total mC number: $tot_mc
----Total C number: $tot_sites
OUT
    last;
    }
    $perc_mc = $tem_perc_mc;
}

open OUT, "+>$out" or die "$!"; 
print OUT "#Final binomial p-value cutoff: $INIT_M\n";
print OUT "#chr\tpos\t#mC\t#mT\tMethOrNot\n";
foreach my $coor(keys %ana_sites){
    my ($chr, $pos, $mc, $dep) = split(/,/, $coor);
    my $pbinom = $ana_sites{"$chr,$pos,$mc,$dep"};
    if($ana_sites{"$chr,$pos,$mc,$dep"} < $INIT_M){
        print OUT "$chr\t$pos\t$mc\t$dep\t$pbinom\tMeth\n";
    }else{
        print OUT "$chr\t$pos\t$mc\t$dep\t$pbinom\tnoMeth\n";
    }
}
close OUT;


=pod
As you mentioned, we use the binomial distribution to call methylation, applying the known non-conversion rate (measured from the lambda unmethylated control DNA spiked into the sample). We treated each context of methylation separately (CG, CHG, CHH), requiring a p-value threshold so that, for example, out of all the mCG we identified (for example), no more than 1% of all the mCG calls would be false positives, taking into account all of the possible sites of CG methylation in the genome.
			The approach is summarized as follows:
			We wanted to identify methylcytosines but keep the number of false positives below 1% of the total number of methylcytosines we identified. The probability p in the binomial distribution B(n,p) was estimated from the number of cytosine bases sequenced in reference cytosine positions in the unmethylated lambda genome (referred to as the error rate: non-conversion plus sequencing error frequency). We interrogated the sequenced bases at each reference cytosine position one at a time, where read depth refers to the number of reads covering that position. For each position, the number of trials (n) in the binomial distribution was the read depth. For each possible value of n we calculated the number of cytosines sequenced (k) at which the probability of sequencing k cytosines out of n trials with an error rate of p was less than the value M, where M * (number of unmethylated cytosines) < 0.01 * (number of methylated cytosines). In this way we established the minimum threshold number of cytosines sequenced at each reference cytosine position where we would call that position methylated, so that out of all methylcytosines identified no more than 1% would be due to the error rate.
			The way we calculate M is through iterative application of our algorithm that uses the binomial test. As we cannot initially know the number of methylated cytosines in the genome to calculate M, we set M = 1. We then perform the binomial test on every cytosine in the genome and every one that returns a probability < 1, we call as methylated. With this "iteration 1" set of the % of cytosines methylated (which we can call %mC) we can then calculate a more accurate (and strict) value for M based on the initial identification of cytosines that could be methylated, as follows:		
			M = 0.01 * %mC / (1 - %mC)
	
			A verbalization of this is as follows: if we estimate that the % of methylated cytosines in the genome is %mC, what is the binomial p-value cut-off that when multiplied by all the unmethylated cytosines in the genome (1 - %mC), gives a falsely identified set of methylcytosines that is only 1% of the total number of methylcytosines we identified. This binomial p-value cutoff is the new M.
			This new value of M will be significantly lower than the initially assumed value of 1. Using the new value of M (new M) we begin a second iteration, testing whether the binomial probability for each cytosine position is < new M. Many of the cytosines identified as methylated in the first iteration now have a binomial probability > new M, and so are no longer called as methylated. This results in a new lower value of %mC, and as a result we must again calculate the next M value based on the new %mC value. This is done as in the equation above, and the next new value of M is used in a third iteration. This iterative process continues until the %mC (and M) no longer change between iterations.
			I have pasted an example below of the iterative process for calling methylation at CHG sites in the H1 methylC-seq data. As you can see the algorithm goes through several iterations and M progressively decreases, and the %mC also decreases, finally stabilizing at 4.404% after 6 iterations.
			Processing for context CHG
			- calculating error from Lambda = 0.00485724
			- building binomial probability table with error: 0.00485724
			- optimizing cutoff with a 0.01 false discovery rate corrected p-value
			- iteration 1, M: 1.000000, %mC: 23.331834%
			- iteration 2, M: 0.003043, %mC: 6.356900%
			- iteration 3, M: 0.000679, %mC: 4.780385%
			- iteration 4, M: 0.000502, %mC: 4.561429%
			- iteration 5, M: 0.000478, %mC: 4.404754%
			- iteration 6, M: 0.000461, %mC: 4.404754%
			- updating calls
			Performing final methylation call update with M = 0.000460771
cut
