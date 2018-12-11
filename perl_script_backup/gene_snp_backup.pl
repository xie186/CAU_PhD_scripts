#!/usr/bin/perl -w
open F,$ARGV[0] or die;
open G,$ARGV[1] or die;
my $snp;
my $lines;
while($snp=<F>){
#	my ($snp_chr,$snp_pos)=(split /\s+/,$one)[0,1];
#	$snp_chr=$snp_chr=~/chr(\d+)/;
#	print "$snp_chr\t$snp_pos\n";
#	my $bb;
#	$_=<G>;
	$lines=<G>;

PATH:{	
	last if !$lines or !$snp;
	chomp $lines;
	chomp $snp;

	my ($snp_chr,$snp_pos)=(split /\s+/,$snp)[0,1];
	($snp_chr)=$snp_chr=~/chr(\d+)/;

	my ($chr,$st,$ed,$gene,$str)=split /\s+/,$lines;
#	print "\t\tsnp is $snp\n\t\tgene is $lines\n";
	if($snp_chr ne $chr){
#		print "bad name\n";
		if($chr!~/\d+/ or $snp_chr>$chr){$lines=<G>}
		else{$snp=<F>}
		redo PATH;
	}

	if($snp_pos<$st){
#		print "less\n";
		$snp=<F>;
		redo PATH;
	}
	elsif($snp_pos>$ed){
#		print "biger\n";
		$lines=<G>;
		redo PATH;
	}
	else{
#		print "good\n";
		print "gene\t$snp\t$gene\n";
		$snp=<F>;
		redo PATH;
	}
 }

}
	

