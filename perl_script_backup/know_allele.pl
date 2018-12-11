#!/usr/bin/perl -w
use strict;
use warnings;

my ($snp,$pileup1,$pileup2,$out)=@ARGV;
my %total;
my %know_snp;
print "hash snp\n";
open F,"$snp" or die;
while(<F>){
	my @tem=split;
	next if /^UNKNOWN/;

	$know_snp{"chr$tem[0]\t$tem[1]"}=[@tem[2,3,5]];
}
close F;
print "look at $pileup1\n";
open G,"$pileup1" or die;
while(<G>){
	my @tem=split;
	next if !$know_snp{"$tem[0]\t$tem[1]"};
	my ($gene,$snp_b,$snp_m)=@{$know_snp{"$tem[0]\t$tem[1]"}};

	my ($seq,$seqq)=trim($tem[-2],$tem[-1]);
	next if !$seq;
	
	my %inf = selfSNP($seq,$tem[2]);
	
	$total{"$tem[0]\t$tem[1]"}="$tem[0]\t$tem[1]\t$tem[2]\t$gene\t$snp_b\t$inf{$snp_b}\t$snp_m\t$inf{$snp_m}";

}
close G;
print "look at $pileup2 and put out results\n";
open OUT,"+>$out" or die;
open H,"$pileup2" or die;
while(<H>){
        my @tem=split;
        next if !$know_snp{"$tem[0]\t$tem[1]"};
	next if !$total{"$tem[0]\t$tem[1]"};
        my ($gene,$snp_b,$snp_m)=@{$know_snp{"$tem[0]\t$tem[1]"}};

        my ($seq,$seqq)=trim($tem[-2],$tem[-1]);
        next if !$seq;

        my %inf = selfSNP($seq,$tem[2]);
	
	print OUT $total{"$tem[0]\t$tem[1]"},"\t$snp_b\t$inf{$snp_b}\t$snp_m\t$inf{$snp_m}\n";
#        $total{"$tem[0]\t$tem[1]"}.="$snp_b\t$inf{$snp_b}\t$snp_m\t$inf{$snp_m}\n";

}


##########################
sub selfSNP{
        my $seq=shift @_;
        my $ref=shift @_;
        my %snp;
        $snp{"A"}=0;
        $snp{"T"}=0;
        $snp{"C"}=0;
        $snp{"G"}=0;

        $snp{$ref}=$seq=~tr/\,\./\,\./;
        $snp{"A"}=$seq=~tr/Aa/Aa/ if $ref ne "A";
        $snp{"T"}=$seq=~tr/Tt/Tt/ if $ref ne "T";
        $snp{"C"}=$seq=~tr/Cc/Cc/ if $ref ne "C";
        $snp{"G"}=$seq=~tr/Gg/Gg/ if $ref ne "G";

	return %snp;
#        my @tt=values %snp;
#        my @array= sort {$snp{$b}<=>$snp{$a}} keys %snp;
#        return ($array[0],$snp{$array[0]},$array[1],$snp{$array[1]});
}

###########################

sub trim{
        my ($s,$q)=@_;
        my @temq=split //,$q;
        my @tems=split //,$s;
        my ($fq,$fs);
        my $x;
        for($x=0;$x<@temq;$x++){
                if(ord($temq[$x])>=48){
                        $fq.=$temq[$x];
                        $fs.=$tems[$x];
                }
        }
        return ($fs,$fq);
}

