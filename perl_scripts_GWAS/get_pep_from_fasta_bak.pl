#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($gene_id,$seq) = @ARGV;

open SEQ,$seq or die "$!";
my @seq = <SEQ>;
my $tem_seq = join("",@seq);
   $tem_seq =~ s/>chr//;
   @seq = split(/>chr/,$tem_seq);
my %hash_seq;
foreach(@seq){
    chomp;
    my ($id,@tem_seq) = split(/\n/);
    my $tem_seq1 = join('',@tem_seq);
#    print "$id\n";
    $hash_seq{$id} = $tem_seq;
}

open ID,$gene_id or die "$!";
while(<ID>){
    chomp;
#    print "$_\n" if !exists $hash_seq{$_}; 
    print ">$_\n$hash_seq{$_}";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <id>  <pep seq>
DIE
}
