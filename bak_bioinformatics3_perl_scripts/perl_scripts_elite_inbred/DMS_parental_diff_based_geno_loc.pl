#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($DMS_geno_loc) = @ARGV;
open DMS,$DMS_geno_loc or die "$!";
my %DMS_geno_loc;
my %DMS_info;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_jug,$chr1,$stt1,$end1,$ele) = split;
    $DMS_geno_loc{"$chr\t$stt"} .= "$ele";
    $DMS_info{"$chr\t$stt"} = "$chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_jug";
}

my %DMS_inher;
foreach(keys %DMS_geno_loc){
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$dms_jug) = split(/,/,$DMS_info{$_});
    if($DMS_geno_loc{$_} =~ /transposon/){
        if($dms_jug eq "Y"){
            ${$DMS_inher{"transposon"}}[1] ++;
        }
        ${$DMS_inher{"transposon"}}[0] ++;
    }elsif($DMS_geno_loc{$_} =~ /exon/){
        if($dms_jug eq "Y"){
            ${$DMS_inher{"exon"}}[1] ++;
        }
        ${$DMS_inher{"exon"}}[0] ++;
    }elsif($DMS_geno_loc{$_} =~ /intron/){
        if($dms_jug eq "Y"){
            ${$DMS_inher{"intron"}}[1] ++;
        }
        ${$DMS_inher{"intron"}}[0] ++;
    }elsif($DMS_geno_loc{$_} =~ /upstream/){
        if($dms_jug eq "Y"){
            ${$DMS_inher{"upstream"}}[1] ++;
        }
        ${$DMS_inher{"upstream"}}[0] ++;
    }elsif($DMS_geno_loc{$_} =~ /downstream/){
        if($dms_jug eq "Y"){
            ${$DMS_inher{"downstream"}}[1] ++;
        }
        ${$DMS_inher{"downstream"}}[0] ++;
    }else{
        if($dms_jug eq "Y"){
            ${$DMS_inher{"intergenic"}}[1] ++;
        }
        ${$DMS_inher{"intergenic"}}[0] ++;
    }
}

foreach(keys %DMS_inher){
    print "$_\t${$DMS_inher{$_}}[0]\t${$DMS_inher{$_}}[1]\n";
}
sub usage{
    my $die =<<DIE;
    perl *.pl <DMS_geno_loc>
DIE
}
