#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($region, $deep_seq) = @ARGV;
open DEEP,$deep_seq or die "$!";
my %hash_inbred;
while(<DEEP>){
    chomp;
    next if /##/;
    my ($cau_acc,$inbred) = split;
    $hash_inbred{$cau_acc} = $inbred;
}
open REG,$region or die "$!";
while(<REG>){
    chomp;
    my ($chr,$stt,$end,$gene) = split;
    foreach my $cau_acc(keys %hash_inbred){
        my $fasta = "./tem_fq/$gene\_$cau_acc.fa";
        print "assemble $fasta\n";
        my $fasta_log = $fasta.".aseembly.log";
        system "/NAS1/software/CAP3/cap3 $fasta -z 2 -u 2 -v 2 -o 20 -j 35 -s 251 -h 80 > $fasta_log";
        my $ctg = "$fasta.cap.contigs";
        my $assemble="$fasta.final_assemble.fa";  ## add the reads taht not asseble
           
        my $map1 = "./tem_fq/$gene\_$cau_acc\_1.fa";
        my $map2 = "./tem_fq/$gene\_$cau_acc\_2.fa";
        print "sccafold! \n";
        my $lib = "$fasta.sspace.lib";
        open F,"+>$lib" or die;
        print F "RG $map1 $map2 500 0.25 0";
        close F; 
        my $scaffold=$fasta.".final_scaffold.fa";
        system "perl /NAS1/software/SSPACE-1.2_linux-x86_64/SSPACE_v1-2.pl -t 5 -k 2 -l $lib  -s $ctg -b $scaffold";
    }
}

sub usage{
    my $die =<<DIE;
    perl *.pl <region> <deep seq line>
DIE
}
