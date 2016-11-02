#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($dir,$prefix) = @ARGV;
my @file = <$dir/*p2log>;
foreach my $file(@file){
    open FILE,$file or die "$!";
    open OUT, "|sort  -k2,2r -k3,3n >$file.asso" or die "$!";
    print OUT "SNP\tchr\tpos\tmaf\tP\n";
    while(my $line = <FILE>){
        my ($chr,$pos,$maf,$pval) = split(/\s+/,$line);
        $pval = 1/(10**$pval);
        next if $pval > 0.05;
        print OUT "chr$chr\_$pos\t$chr\t$pos\t$maf\t$pval\n";
    }
    close OUT;
    print "plink --noweb --clump-p1 0.0000000516 --clump-p2 0.00001 --clump-r2 0.30 --clump-kb 50 --bfile $prefix --clump $file.asso --out $file.clumped &\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <dir> <prefix>
DIE
}
