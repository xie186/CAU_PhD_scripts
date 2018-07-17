#!/usr/bin/perl -w
use strict;

my ($sam_list, $dir, $seq, $out) = @ARGV;

die usage() unless @ARGV == 4;
sub usage{
    my $die =<<DIE;
perl *.pl <sam list> <dir> <target_seq> <out> 
DIE
}

open FA, $seq or die "$!";
my %rec_id;
while(<FA>){
    chomp;
    next if !/^>/;
    $_ =~ s/>//g;
    my ($id) = split(/\s+/, $_);
    $rec_id{$id} ++;
}
close FA;

open OUT, "+>$out" or die "$!";
#open OUTDNA, "+>$out_prefix.dnas.fa" or die "$!";
open SAM, $sam_list or die "$!";
while(<SAM>){
    chomp;
    #1kP_Sample,Clade,Family,Species,Tissue Type,Status,Voucher Data,Sample Provider,RNA Extractor
    my ($sam) = split(/,/, $_);
    if(-e "$dir/$sam-SOAPdenovo-Trans-assembly.dnas_uniID.out"){
         open IN, "$dir/$sam-SOAPdenovo-Trans-assembly.dnas_uniID.out" or die "$!";
         while(my $line = <IN>){
             if($line =~ />/){
                 my ($scaf, $acc, $num, $species_name) = split(/-/, $line);
                 my $seq = <IN>;
                 my $q_id = "$acc-$num";
                 print OUT ">$q_id\n$seq" if exists $rec_id{$q_id};
                 delete $rec_id{$q_id} if $rec_id{$q_id};
             }
         }
         close IN;
    }else{
        print "No prot seq: $_\n";
    } 
}
close SAM;
close OUT;

foreach(keys %rec_id){
    print "$_\n";
}
