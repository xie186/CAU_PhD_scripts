#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($snp,$out) = @ARGV;
open SNP,$snp or die "$!";
open OUT,"+>$out" or die;
while(<SNP>){

    my ($chr,$pos,$ref,$ref_nu,$alle1,$nu1,$alle2,$nu2) =split;
    my $pvalue="NULL";
       $pvalue=test($nu2,$ref_nu,0.05,"great");
    print OUT "$chr\t$pos\t$ref\t$ref_nu\t$alle1\t$nu1\t$alle2\t$nu2\t$pvalue\n";
}
close SNP;
close OUT;
#########################

sub test{
	my $suc=shift @_;
	my $deep=shift @_;
	my $hy_rate=shift @_;
	my $alt=shift @_;
	open R,"+>$snp.R";
	print R "binom.test($suc,$deep,$hy_rate,alternative=\"$alt\");";
	close R;
	system "R --vanilla --slave < test.R > test.out";
#	system "R --no-restore --no-save --no-readline < test.R > test.out";
	open RO,"test.out" or die;
	while(my $ol=<RO>){
		if($ol=~/p-value = (\d+\.\d+)/){
			return $1;
		}
	}
}

sub usage{
    print <<DIE;
    perl *.pl <SNP> <output>
DIE
    exit 1;
}
