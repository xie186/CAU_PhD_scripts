#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==3;
sub usage{
    my $die =<<DIE;
    perl *.pl <maize fasta> <sorghum fasta> <region>
DIE
}
my ($zm_fa,$sorghum_fa,$region) = @ARGV;

open ZM,$zm_fa or die "$!";
my @zm_seq = <ZM>;
my $zm_seq = join('',@zm_seq);
   $zm_seq =~ s/>//;
   @zm_seq = split(/>/,$zm_seq); 
my %seq_zm;
foreach(@zm_seq){
    my ($chr,@seq) = split(/\n/,$_);
    my $seq = join("",@seq);
    $chr=~ s/chr//g;
    $seq_zm{$chr} = $seq;
}

open SOR,$sorghum_fa or die "$!";
my @sor_seq = <SOR>;
my $sor_seq = join('',@sor_seq);
   $sor_seq =~ s/>//;
   @sor_seq = split(/>/,$sor_seq);
my %seq_sor;
foreach(@sor_seq){
    my ($chr,@seq) = split(/\n/,$_);
    my $seq = join("",@seq);
    (my $sca,$chr) = split(/_/,$chr);
    $seq_sor{$chr} = $seq;
}

`mkdir fasta_dir` if !-e "fasta_dir";
open REGION,$region or die "$!";
while(<REGION>){
    chomp;
    #leaf_width      7       33524546        33543102        sorghum_2_11482047_18051188     maize_7_27669317_44456929
    my ($phe,$chr,$stt,$end,$sor_coor,$zm_coor)  = split(/\t/);
    my ($chr1,$stt1,$end1) = $sor_coor =~ /_(\d+)_(\d+)_(\d+)/;
    my ($chr2,$stt2,$end2) = $zm_coor =~ /_(\d+)_(\d+)_(\d+)/;
    my $tem_seq_sor = substr($seq_sor{$chr1}, $stt1 - 1, $end1 - $stt1 + 1);
    my $tem_seq_zm = substr($seq_zm{$chr2}, $stt2 - 1, $end2 - $stt2 + 1);
    open OUT2,"+>./fasta_dir/sorghum\_$chr1\_$stt1\_$end1.fa" or die "$!";
    print OUT2 ">sorghum\_$chr1\_$stt1\_$end1\n$tem_seq_sor\n";
    open OUT2,"+>./fasta_dir/maize\_$chr2\_$stt2\_$end2.fa" or die "$!";
    print OUT2 ">maize\_$chr2\_$stt2\_$end2\n$tem_seq_zm\n";
}

