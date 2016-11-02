#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($geno,$iso,$gtf) = @ARGV;

open SEQ,$geno or die "$!";
my @aa=<SEQ>;
my $join=join'',@aa;
   @aa=split(/>/,$join);
shift @aa;
my %hash;
foreach(@aa){
    my ($chr,@seq)=split(/\n/,$_);
       my $seq=join'',@seq;
       $hash{$chr}=$seq;
}

open ISO,$iso or die "$!";
my %hash_inclu;
while(<ISO>){
    chomp;
    my ($chr,$stt,$end,$iso,$gene_id) = split;
    $hash_inclu{$gene_id} ++;
}
close ISO;

open GTF,$gtf or die "$!";
my %hash_seq;
while(<GTF>){
    chomp;
    my ($chr,$tool,$ele,$stt,$end,$dot1,$strand,$dot2,$id) = split(/\t/);
    next if $ele ne "exon";
    my ($gene_id,$iso_id) = $id =~ /gene_id "(.*)"; transcript_id "(.*)"; exon_number /;
#    print "xx$gene_id,$iso_id\n";
    if(exists $hash_inclu{$gene_id}){
        my $tem_seq = substr($hash{$chr},$stt-1,$end-$stt+1) ;
        if($strand eq "-"){
           $tem_seq = reverse $tem_seq;
           $tem_seq =~ tr/ATGC/TACG/;
           unshift @{$hash_seq{$iso_id}},$tem_seq;
        }else{
           push @{$hash_seq{$iso_id}},$tem_seq;
        }
    }
}

foreach(keys %hash_seq){
    my $nu = @{$hash_seq{$_}};
    my $tem_seq = join('',@{$hash_seq{$_}});
    print ">$_\t$nu\n$tem_seq\n";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <genome> <isoform>  <gtf>
DIE
}
