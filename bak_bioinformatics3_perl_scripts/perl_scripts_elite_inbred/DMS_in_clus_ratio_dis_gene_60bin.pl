#!/usr/bin/perl -w

use strict;
die usage() unless @ARGV == 2;
my ($anno, $dms)=@ARGV;
my $BIN = 60;

open ANNO,$anno or die "$!";
my %hash_anno;
while(<ANNO>){
    chomp;
    my ($chr,$stt,$end,$c1,$t1,$c2,$t2,$lev1,$lev2,$diff,$pval,$qval,$tem_chr,$tem_stt,$tem_end,$type) = split;
    $hash_anno{"$chr\t$stt"} .= "$type\t";
}

foreach(keys %hash_anno){
        if($hash_anno{$_} =~ /transposon/){
                $hash_anno{$_} = "Transposon";
        }elsif($hash_anno{$_} =~ /exon/){
                $hash_anno{$_} = "Exon";
        }elsif($hash_anno{$_} =~ /intro/){
                $hash_anno{$_} = "Intron";
        }elsif($hash_anno{$_} =~ /upstream/){
                $hash_anno{$_} = "Upstream";
        }elsif($hash_anno{$_} =~ /downstream/){
                $hash_anno{$_} = "Downstream";
        }else{
                $hash_anno{$_} = "Intergenic";
        }
}

my %dms_stat;
open DMS,$dms or die "$!";
while(<DMS>){
    chomp;
    my ($chr,$stt,$end,$id) = split;
    my @id = split(/;/, $id);
    my $num = @id;
    foreach my $tem_id(@id){
        my ($tem_chr,$tem_stt) = split(/_/, $tem_id);
        print "$tem_chr,$tem_stt\n" if !exists $hash_anno{"$tem_chr\t$tem_stt"};
        my $type = $hash_anno{"$tem_chr\t$tem_stt"};
        if($num == 1){
            ${$dms_stat{$type}}[0] ++;  ## not in cluster
        }else{
            ${$dms_stat{$type}}[1] ++;  ## in cluster
        }
    }
}

foreach(keys %dms_stat){
     my $ratio = ${$dms_stat{$_}}[1] / (${$dms_stat{$_}}[1] + ${$dms_stat{$_}}[0]);
     print "$_\t$ratio\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <DMS anno> <DMS_clus> <Gene position> <OUTPUT>
    This is to get ratio of  DMSs in cluster distribution throughth gene
DIE
}
