#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==2;
my ($region,$syn_region) = @ARGV;
open REG,$region or die "$!";
my %gwas_region;
while(<REG>){
    #../LD_group_LD_decay_peak_snp/result_2011_peak_snp_ld_decay_reg_WGS.res:##KNPR  region  chr6    10038190        10047650        1       0
    chomp;
    my ($phe,$type,$chr,$stt,$end) = split;
    $chr =~ s/chr//g;
    ($phe) = $phe =~ /##(.*)/;
    $gwas_region{"$phe\t$chr\t$stt\t$end"} ++;
#    print "$phe\t$chr\t$stt\t$end\n";
}

open SYN,$syn_region or die "$!";
my @block = <SYN>;
my $block = join("",@block);
   $block =~ s/###//;
   @block = split(/###/,$block); 

foreach(@block){
    chomp;
    my ($block_reg, @gene_pair) = split(/\n/);
    my ($zm_chr,$zm_stt,$zm_end) = $block_reg =~ /maize_(\d+)_(\d+)_(\d+)/;
    foreach my $asso_region( keys %gwas_region){
        my ($phe,$chr,$stt,$end) = split(/\t/,$asso_region);
#        print "xx$phe,$chr,$stt,$end.xx$asso_region\n";
        if($chr == $zm_chr && $stt >= $zm_stt && $end <= $zm_end){
            print "$asso_region\t$block_reg\n";
        }
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <region associated> <syntenic regions> 
DIE
}
