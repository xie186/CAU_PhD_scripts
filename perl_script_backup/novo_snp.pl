#!/usr/bin/perl -w
use strict;
open F,$ARGV[0] or die;
die "$ARGV[1] exists!!!" if -e $ARGV[1];
open OUT,"+>$ARGV[1]" or die;
while(<F>){
#	print "it is $ff\n";
	my ($gene,$pos,$ref,$deep,$seq)=(split)[0,1,2,3,4];
	next if $ref eq "*";
	my %snp=selfSNP($seq,$ref);
	
	my @arr=sort {$snp{$b}<=>$snp{$a}} keys %snp;
#	print "they are $snp{$arr[0]} and $snp{$arr[1]}\n";
	next if $deep<10 or $snp{$arr[1]}<=0;
	my $pvalue="NULL";
#	$pvalue=test($snp{$arr[1]},$deep,0.05,"great");
#	print "yes\n";
	print OUT "$gene\t$pos\t$ref\t$deep\t$arr[0]\t$snp{$arr[0]}\t$arr[1]\t$snp{$arr[1]}\t$pvalue\n";	
}
close F;
close OUT;
#########################

sub test{
	my $suc=shift @_;
	my $deep=shift @_;
	my $hy_rate=shift @_;
	my $alt=shift @_;
	open R,"+>test.R";
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

######################
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

