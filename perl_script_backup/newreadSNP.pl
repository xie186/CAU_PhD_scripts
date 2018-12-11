#!/usr/bin/perl -w
use strict;
die("usage: perl newreadSNP.pl <BB> <MM> <SNP> \n") unless @ARGV==3;
open F, $ARGV[0] or die;
open G, $ARGV[1] or die;
open OUT, "+>$ARGV[2]" or die;
#find com


while( my $line1=<F>){
	my $line2=<G>;
	last if !$line2;
	last if $line1=~/\bchr0\b/ or $line2=~/\bchr0\b/;
#to same chr
	my @cc=($line1,$line2);
	while($cc[-1] ne "sam1"){
		@cc=comc(@cc);
		last if !$cc[0] or !$cc[1];
	}
	last if !$cc[0] or !$cc[1];

#to sam position

	my @pp=@cc[0,1];
	while($pp[-1] ne "sam"){
		@pp=comp(@pp);
		if($pp[-1] eq "bad"){
			@pp=comc(@pp);
			redo;
		}
		last if !$pp[0] or !$pp[1];
	}
	last if !$pp[0] or !$pp[1];
#	redo if $pp[0] eq "bad";
#	print "ti is $pp[0],$pp[1],##$line1 $line2\n" if !$pp[1];
	my @tem1=split /\s+/,$pp[0];
	my @tem2=split /\s+/,$pp[1];
	next if $tem1[7]<5 || $tem2[7]<5;

# find SNP,self or inter

	
	my ($gene,$pos1,$ref,$seq1,$sq1)=@tem1[0,1,2,8,9];
	my ($seq2,$sq2)=@tem2[8,9];
	
	my @inf1=trim($seq1,$sq1);
	my @inf2=trim($seq2,$sq2);
	next if !$inf1[0] or !$inf2[0];
	next if $inf2[-1]<5 and $inf1[-1]<5;
#	print "@inf1\t@inf2\n";
	my @snp1=selfSNP($inf1[0],$ref);
	my @snp2=selfSNP($inf2[0],$ref);
#	print "it is @snp1\t##@snp2\n";

	if($snp1[1]/$inf1[-1]>0.8 and $snp2[1]/$inf2[-1]>0.8 and $snp1[0] ne $snp2[0] ){
		print OUT "$gene\t$pos1\t$ref\t$snp1[0]\t$snp1[1]\t$snp1[2]\t$snp1[3]\t$inf1[-1]\t$snp2[0]\t$snp2[1]\t$snp2[2]\t$snp2[3]\t$inf2[-1]\n";
	}
#	elsif($snp1[0] ne $snp2[0]){
#		print OUT "$gene\t$pos1\t$ref\t$snp1[0]\t$snp1[1]\t$snp1[2]\t$snp1[3]\t$inf1[-1]\t$snp2[0]\t$snp2[1]\t$snp2[2]\t$snp2[3]\t$inf2[-1]\n";
#	}


}
############################
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
	my @tt=values %snp;
	my @array= sort {$snp{$b}<=>$snp{$a}} keys %snp;
	return ($array[0],$snp{$array[0]},$array[1],$snp{$array[1]});
}
###########################

sub trim{
        my ($s,$q)=@_;
        my @temq=split //,$q;
        my @tems=split //,$s;
        my ($fq,$fs);
        my $x;
	my $dep=0;
        for($x=0;$x<@temq;$x++){
                if(ord($temq[$x])>=48){
			$dep++;
                        $fq.=$temq[$x];
                        $fs.=$tems[$x];
                }
        }
        return ($fs,$fq,$dep);
}
############################

sub comp{
	my ($line1,$line2)=@_;
	return if !$line1 or !$line2;
	my @tem1=split /\s+/,$line1;
	my @tem2=split /\s+/,$line2;
		if($tem1[0] ne $tem2[0]){
#			print "bad,@tem1[0,1],@tem2[0,1]\n";
			return ($line1,$line2,"bad");
		}
#		print "p is $tem1[1] $tem2[1]\n";
	        if($tem1[1]<$tem2[1]){
	        	$line1=<F>;
			return ($line1,$line2);
	        }
	        elsif($tem1[1]>$tem2[1]){
	                $line2=<G>;
			return ($line1,$line2);
	        }
	        else{
	                return ($line1,$line2,"sam");
		}
}

###########################
sub comc{
	my ($line1,$line2)=@_;
	my @tem1=split /\s+/,$line1;
	my @tem2=split /\s+/,$line2;

	if($tem1[0] lt $tem2[0]){
#		print "1<2!:$tem1[0]\t$tem1[1]\t$tem2[0]\t$tem2[1]\n";
		$line1=<F>;
		return ($line1,$line2);
	}
	elsif($tem1[0] gt $tem2[0]){
#		print "1>2!: $tem1[0]\t$tem1[1]\t$tem2[0]\t$tem2[1]\n";
		$line2=<G>;
		return ($line1,$line2);
	}
	else{
#		print "1==2\n";
		return ($line1,$line2,"sam1");
	}
}
