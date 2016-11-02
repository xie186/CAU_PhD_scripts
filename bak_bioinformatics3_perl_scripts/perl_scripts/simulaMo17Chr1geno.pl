#!/usr/bin/perl -w
use strict;
my $die=<<DIE;
Usage: perl *.pl <SNP><GENO><OUTPUT:simulate_genome>.
DIE
die "\n$die\n" unless @ARGV==3;
my ($snp,$geno,$out)=@ARGV;
open SNP,$snp or die;
my %snp;
while(<SNP>){
    chomp;
    my ($chr,$pos,$baseB,$baseMo)=(split(/\s+/,$_))[0,1,2,3];
    @{$snp{"$chr\t$pos"}}=($baseB,$baseMo);
}

open CHR,$geno or die;
my @geno=<CHR>;
my $tem=join'',@geno;
   @geno=split(/>/,$tem);
open OUT,"+>$ARGV[2]" or die;
foreach(@geno){
    my ($chr,@seq)=split(/\n/,$_);
    next if !$chr;
    chomp @seq;
    my $seq=join'',@seq;
    print "go go go!";
    my $mo17;
    for(my $i=1;$i<=length $seq;++$i){
        my $base=substr($seq,$i-1,1);
        if(exists $snp{"$chr\t$i"}){
            print "$base\t@{$snp{\"$chr\t$i\"}}\n";
            $mo17.=${$snp{"$chr\t$i"}}[-1];
        }else{
            $mo17.="$base";
        }
    }
    print OUT ">$chr\n$mo17\n";
}
close OUT;
