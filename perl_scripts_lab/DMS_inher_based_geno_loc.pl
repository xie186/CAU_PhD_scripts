#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($DMS_geno_loc) = @ARGV;
open DMS,$DMS_geno_loc or die "$!";
my %DMS_geno_loc;
my %DMS_info;
while(<DMS>){
    chomp;
    #chr1    242101  242200  807_to_c24_CpG_hyper    chr1    240843  242842  Downstream      99
    my ($chr, $stt, $end, $ele) = (split)[0,1,2,-2];
    $DMS_geno_loc{"$chr\t$stt\t$end"} .= "$ele";
    $DMS_info{"$chr\t$stt\t$end"} = "$chr, $stt, $end, $ele";
}

my %DMS_inher;
foreach(keys %DMS_geno_loc){
    my ($chr, $stt, $end, $ele) = split(/,/,$DMS_info{$_});
    if($DMS_geno_loc{$_} =~ /TE/){
        $DMS_inher{"TE"} ++;
    }elsif($DMS_geno_loc{$_} =~ /Gene/){
        $DMS_inher{"Gene"} ++;
    }elsif($DMS_geno_loc{$_} =~ /Upstream/){
        $DMS_inher{"Upstream"} ++;
    }elsif($DMS_geno_loc{$_} =~ /Downstream/){
        $DMS_inher{"Downstream"} ++;
    }else{
        $DMS_inher{"Intergenic"} ++;
    }
}

foreach(keys %DMS_inher){
    print "$_\t$DMS_inher{$_}\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <DMS_geno_loc>
DIE
}
