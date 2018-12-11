#!/usr/bin/perl -w
die("usage:perl call_known.pl <snp> <BM pileup> <MB pileup> <output> \n") unless @ARGV==4;
open F,"$ARGV[0]" or die;
while(<F>){
	my @tem=split;
	$hash{"$tem[0]\t$tem[1]"}=[$tem[4],$tem[6]];

}
print "search bm\n";
my %bm;
open G,"$ARGV[1]" or die;
while(<G>){
	my @tem=split;
	my $line;
	if($hash{"$tem[0]\t$tem[1]"}){
		my $ba=$hash{"$tem[0]\t$tem[1]"}->[0];
		my $ma=$hash{"$tem[0]\t$tem[1]"}->[1];

		my %snp=selfSNP($tem[-2],$tem[2]);
		$bm{"$tem[0]\t$tem[1]"}="$ba\t$snp{$ba}\t$ma\t$snp{$ma}";
	}
}

print "search mb\n";
my %mb;
open H,"$ARGV[2]" or die;
while(<H>){
        my @tem=split;
        my $line;
        if($hash{"$tem[0]\t$tem[1]"}){
		my $ba=$hash{"$tem[0]\t$tem[1]"}->[0];
		my $ma=$hash{"$tem[0]\t$tem[1]"}->[1];

                my %snp=selfSNP($tem[-2],$tem[2]);
                $mb{"$tem[0]\t$tem[1]"}="$ba\t$snp{$ba}\t$ma\t$snp{$ma}";
        }
}

print "output\n";
open OUT,"+>$ARGV[3]" or die;
open F,"$ARGV[0]" or die;
while(<F>){
        my @tem=split;
	
	if($mb{"$tem[0]\t$tem[1]"} and $bm{"$tem[0]\t$tem[1]"}){
		print OUT "$tem[0]\t$tem[1]\t",$bm{"$tem[0]\t$tem[1]"},"\t",$mb{"$tem[0]\t$tem[1]"},"\n";
	}

}


##############################
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

