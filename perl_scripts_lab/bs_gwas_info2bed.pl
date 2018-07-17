#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($meth_dir, $out) = @ARGV;

sub usage{
   my $die =<<DIE;
perl $0 <meth_dir> <out>        >> ecotype list
DIE
}

open OUT, "+>$out" or die "$!";
my @meth_file = <$meth_dir/*.tsv.gz>;
#GSM1085334_mC_calls_Westkar_4_bud.tsv.gz
foreach(@meth_file){
    chomp;
    open METH, "zcat $_|" or die "$!";
    print "$_\n";
    my ($eco) = $_ =~ /GSM\d+_mC_calls_(.*).tsv.gz/;
    $eco =~ s/_bud//g; 
    while( my $line = <METH>){
        #chrom   pos     strand  mc_class        methylated_bases        total_bases     methylation_call
	next if $line =~ /chrom/;
	my ($chr, $pos, $strand, $mc_class, $num_c, $tot) = split(/\s+/, $line);
        my $class = &judge_class($mc_class);
        $chr = "chr".$chr;
        $pos += 1;
        print OUT "$chr\t$pos\t$pos\t$eco\t$class\t$num_c\t$tot\n";
    }
} 

close OUT;
sub judge_class{
    my ($mc_class) = @_;
    if($mc_class =~ /^CG/){
        return "CpG";
    }elsif($mc_class =~ /^C[A|T|C]G/){
        return "CHG";
    }else{
        return "CHH";
    }
}
