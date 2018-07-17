#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($dmr_pair, $cutoff) = @ARGV;

open PAIR, $dmr_pair or die "$!";
print "sample2\tsamp1\tCpG_hyper\tCpG_hypo\tCHG_hyper\tCHG_hypo\tCHH_hyper\tCHH_hypo\n";
while(<PAIR>){
    chomp;
    my ($wt,$mut) = split;
    next if /^#/;
    my $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CHH.fisherBH |awk '\$12< $cutoff && \$10 < 0'|wc -l);    
    my $CHH_hyper = `$cmd`;
       $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CHH.fisherBH|awk '\$12< $cutoff && \$10 > 0'|wc -l);
    my $CHH_hypo = `$cmd`;
       $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CHG.fisherBH |awk '\$12< $cutoff && \$10 > 0'|wc -l);
    my $CHG_hyper = `$cmd`;
       $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CHG.fisherBH |awk '\$12< $cutoff && \$10 < 0'|wc -l);
    my $CHG_hypo = `$cmd`;
       $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CpG.fisherBH |awk '\$12< $cutoff && \$10 > 0'|wc -l);
    my $CpG_hyper = `$cmd`;
       $cmd = qq(grep -v 'stt' bed_$wt\_$mut\_OTOB_CpG.fisherBH |awk '\$12< $cutoff && \$10 < 0'|wc -l);
    my $CpG_hypo = `$cmd`;
    chomp $CHH_hyper;chomp $CHH_hypo;
    chomp $CHG_hyper;chomp $CHG_hypo;
    chomp $CpG_hyper;chomp $CpG_hypo;
    print "$wt\t$mut\t$CpG_hyper\t$CpG_hypo\t$CHG_hyper\t$CHG_hypo\t$CHH_hyper\t$CHH_hypo\n";
}

sub usage{
    my $die =<<DIE;
perl $0 <DMR pair>
DIE
}
