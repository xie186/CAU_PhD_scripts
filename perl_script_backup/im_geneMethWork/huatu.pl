#!/usr/bin/perl -w
use strict;

while(<>){
    chomp;
    system qq(perl plot_xie_gene.pl $_.stru $_.en1_bwa_m.pileup $_.en2_bwa_m.pileup $_.snp >$_.svg);
}
