#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV == 3;
my ($geno_len,$pDMR,$smRNA) = @ARGV;

open LEN,$geno_len or die "$!";
my %hash_geno;my @chr;my $chr_nu = 0;
while(<LEN>){
    chomp;
    my ($chr,$len) = split;
    next if ($chr eq "chr1" ||$chr eq "chr11" ||$chr eq "chr12");
    push @chr,$len;
    ++$chr_nu;
}
my %hash;
my $rd_tot;
open SM,$smRNA or die "$!";
while(<SM>){
    chomp;
    my ($chr,$stt,$end,$id,$null,$strand) = split;
    my $mid = int (($stt+$end)/2);
    my ($rd_id,$rd_len,$rd_nu) = split(/_/,$id);
    $hash{"$chr\t$mid"} = $rd_nu;
    $rd_tot += $rd_nu;
}

open DMR,$pDMR or die "$!";
while(<DMR>){
    chomp;
    my ($chr,$stt,$end) = split;
    my $smrna_nu = 0;
    for(my $i = $stt; $i <= $end; ++$i){
         if(exists $hash{"$chr\t$i"}){
             $smrna_nu += $hash{"$chr\t$i"};
         }
    }
    my $rpm = $smrna_nu*1000000/$rd_tot;

    my $chr_rand = int (rand($chr_nu));
    my $seq_rand = int (rand($chr[$chr_rand]));
       $chr_rand +=1;
       $smrna_nu = 0;
    for(my $i = $seq_rand; $i <= $seq_rand+$end-$stt+1; ++$i){ 
#         print "test\tchr$chr_rand\t$i\n";
         if(exists $hash{"chr$chr_rand\t$i"}){
#             print "xx$smrna_nu\n";
             $smrna_nu += $hash{"chr$chr_rand\t$i"};
         }
    }
    my $rpm_rank = $smrna_nu*1000000/$rd_tot;
    print "$chr\t$stt\t$end\t$rpm\t$rpm_rank\n";
}

sub usage{
    print <<DIE;
perl *.pl <Genome length> <DMR position> <smRNA bed>
DIE
   exit 1;
}
