#!/usr/bin/perl -w
use strict;

my ($blast, $pep_seq, $e_cut) = @ARGV;

die usage() unless @ARGV == 3;
sub usage{
    my $die =<<DIE;
perl *.pl <blast> <pep_seq> <e value cutoff> 
DIE
}

open BLAST, $blast or die "$!";
my %rec_blast_res;
while(<BLAST>){
    chomp;
    my ($q_id, $s_id, $pident, $length, $mismatch, $gapopen, $qstart, $qend, $sstart, $send, $evalue, $bitscore) = split;
    next if $evalue > $e_cut; 
    my ($scaf, $acc, $num, $spec) = split(/-/, $q_id);
    push @{$rec_blast_res{"$acc-$num"}}, $_;
}
close BLAST;

my %rec_candi;
foreach(keys %rec_blast_res){
    chomp;
    my @hits = @{$rec_blast_res{$_}};
    my $num = @hits;
    if($num == 14){  ## 14 PYLs in arabidopsis
        my ($q_id, $s_id, $pident, $length, $mismatch, $gapopen, $qstart, $qend, $sstart, $send, $evalue, $bitscore) = split(/\s+/, $hits[0]);
        $rec_candi{$_} = "$_;$s_id;$evalue";
    }
}

$/ = "\n>";
my %rec_seq_print;
open FA, $pep_seq or die "$!";
while(<FA>){
   chomp;
   $_=~s/>//g;
   my ($id, $seq) = split(/\n/, $_, 2);
   my ($scaf, $acc, $num, $species_name) = split(/-/, $id);
   my $q_id = "$acc-$num";
   $species_name = lc $species_name;
   if(exists $rec_candi{$q_id} && !exists $rec_seq_print{$seq}){
       print ">$q_id $species_name\t$rec_candi{$q_id}\n$seq\n";
       $rec_seq_print{$seq} ++;
   }
}
$/ = "\n";
