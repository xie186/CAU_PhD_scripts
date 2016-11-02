#!/usr/bin/perl -w
use strict;
use Statistics::R;
my ($out) = @ARGV;
my $R = Statistics::R->new();

open OUT,"+>$out" or die "$!";
my @file = <inner_size/*insert>;
foreach(@file){
    my $cmd =<<EOF;
    cc <- read.table("$_");
    mean_v <- mean(abs(cc[,2]))
    sd_v <- sd(abs(cc[,2]))
EOF
    $R -> run($cmd);
    my $mean = $R -> get("mean_v");
    my $sd = $R -> get("sd_v");
    my $file = $_;
    $file =~s/insert/gz/g;
    $file =~s/test.//g;
    $file =~s/inner_size\///g;
    $file =~s/fq\.//g;
    print "$file\t$mean\t$sd\n";
    my $read2 = $file;
       $read2 =~ s/R1/R2/g;
    my $inner = int($mean) -200;
       $sd = int($sd);
    my $out_dir = $file;
       $out_dir  =~ s/.R1.clean.fastq.gz//g;
    print OUT "perl /NAS1/zeamxie/perl_scripts_part2/run_tophat_cufflinks.pl $file $read2 $inner $sd 2.0.4 2.0.2 $out_dir\_tophat $out_dir\_cufflink\n"; 
}

sub usage{
    my $die=<<DIE;
    perl *.pl <OUT cmd> 
DIE
}

