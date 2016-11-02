#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 1;
my ($DMS_geno_loc) = @ARGV;
open DMS,$DMS_geno_loc or die "$!";
my %DMS_geno_loc;
my %DMS_info;
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$all_sites,$stab,$chr1,$stt1,$end1,$ele) = split;
    $DMS_geno_loc{"$chr\t$stt\t$end"} .= "$ele";
    $DMS_info{"$chr\t$stt\t$end"} = "$all_sites,$stab";
}

my %DMS_inher;
foreach(keys %DMS_geno_loc){
    my ($all_sites,$stab) = split(/,/,$DMS_info{$_});
    if($DMS_geno_loc{$_} =~ /transposon/){
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"transposon"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"transposon"}}[1] ++;
        }
    }elsif($DMS_geno_loc{$_} =~ /exon/){
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"exon"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"exon"}}[1] ++;
        }
    }elsif($DMS_geno_loc{$_} =~ /intron/){
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"intron"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"intron"}}[1] ++;
        }
    }elsif($DMS_geno_loc{$_} =~ /upstream/){
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"upstream"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"upstream"}}[1] ++;
        }
    }elsif($DMS_geno_loc{$_} =~ /downstream/){
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"downstream"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"downstream"}}[1] ++;
        }
    }else{
        if($stab / $all_sites > 0.8){
            ${$DMS_inher{"intergenic"}}[0] ++;
        }elsif($stab / $all_sites < 0.2){
            ${$DMS_inher{"intergenic"}}[1] ++;
        }
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
