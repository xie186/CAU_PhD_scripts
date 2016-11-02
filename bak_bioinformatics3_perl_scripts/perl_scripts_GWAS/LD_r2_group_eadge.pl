#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($ld,$r2_cut, $out) = @ARGV;

open LD,$ld or die "$!";
my %ld_cal;
while(<LD>){
    chomp;
    next if /CHR_A/;
    #     1      4798974      chr1_4798974      1      4305886      chr1_4305886     0.123142
    my ($chr1,$pos1,$rs1,$chr2,$pos2,$rs2,$r2) = split;
    push @{$ld_cal{"$chr1\t$pos1"}} , $pos2 if $r2 >= $r2_cut;
}

open OUT,"+>$out" or die "$!";
my $singleton_num = 0;
foreach(keys %ld_cal){
    my $snp_num = @{$ld_cal{"$_"}};
    if($snp_num <=2){
        print "$_\n";
        ++$singleton_num; 
        next;
    }
    my ($stt,$end) = (sort{$a<=>$b} @{$ld_cal{"$_"}})[0,-1];
    my $len = $end - $stt + 1; 
    print OUT "$_\t$stt\t$end\t$snp_num\t$len\n";
}

print "Total_singleton_SNP:	$singleton_num\n";
sub usage{
    my $die =<<DIE;
    perl *.pl <ld > <r2_cut> <OUTOUT> 
DIE
}
