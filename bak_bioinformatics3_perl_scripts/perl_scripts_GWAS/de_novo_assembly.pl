#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($clus, $prop_cut,$gene, $ge_pos) = @ARGV;
open GENE,$ge_pos, or die "$!";
my $gene_pos = 0;
while(<GENE>){
    my ($chr,$stt,$end,$tem_gene) = split;
       $chr = "chr".$chr if $chr !~ /chr/;
      ($stt,$end) = ($stt - 2000, $end + 2000);
    $gene_pos = "$chr:$stt-$end" if $gene eq $tem_gene;
}
open CLUS,$clus or die "$!";
my $haplo_group = 1;
my %hash_group;
while(<CLUS>){
    chomp;
    my($id1,$id2,$prop,$tot_inbred,$inbred_name)  = split;
    next if $prop < $prop_cut;
    my @inbred_name = split(/-/,$inbred_name);
    push @{$hash_group{$haplo_group}},@inbred_name;
    ++ $haplo_group;
}

foreach my $group(keys %hash_group){
        my $fasta = "./tem_fq/$gene\_group$group.fa";
        print "assemble $fasta\n";
        my $fasta_log = $fasta.".aseembly.log";
        system "/NAS1/software/CAP3/cap3 $fasta -z 2 -u 2 -v 2 -o 20 -j 35 -s 251 -h 80 > $fasta_log";
        my $ctg = "$fasta.cap.contigs";
        my $assemble="$fasta.final_assemble.fa";  ## add the reads taht not asseble

        my $map1 = "./tem_fq/$gene\_group$group\_1.fa";
        my $map2 = "./tem_fq/$gene\_group$group\_2.fa";
        print "sccafold! \n";
        my $lib = "$fasta.sspace.lib";
        open F,"+>$lib" or die;
        print F "RG $map1 $map2 500 0.25 0";
        close F;
        my $scaffold = "$gene\_group$group.fa";
        system "perl /NAS1/software/SSPACE-1.2_linux-x86_64/SSPACE_v1-2.pl -t 5 -k 2 -l $lib  -s $ctg -b $scaffold";
        `mv $scaffold.* tem_fq/`; 
} 

sub usage{
    my $die =<<DIE;
    perl *.pl  <clust>  <percentage cutoff> <gene> <gene position> <bam file dir>
DIE
}
