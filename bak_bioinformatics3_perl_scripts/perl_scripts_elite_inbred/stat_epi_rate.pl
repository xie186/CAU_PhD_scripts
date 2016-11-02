#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==3;
my ($dms, $process, $qvalue) = @ARGV;
my @dms = split(/,/, $dms);
my @proc = split(/,/, $process);
for(my $i = 0; $i < @dms; ++$i){
    open DMS, $dms[$i] or die "$!";
    my ($num_dms, $num_cytosine) = (0,0);
    while(my $line = <DMS>){
        chomp $line;
	my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval) = split(/\t/, $line);
	if($qval < $qvalue){
	    ++$num_dms;
        }
        ++ $num_cytosine;
    }
    print "$proc[$i]\t$num_dms\t$num_cytosine\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <DMS> <processes>  <q value cutoff>
DIE
}
