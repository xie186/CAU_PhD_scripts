#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 2;
my ($gene_id,$seq) = @ARGV;

open SEQ,$seq or die "$!";
my %hash_seq;
while(my $id = <SEQ>){
    chomp $id;
    $id =~ s/>chr//;
    my $tem_seq = <SEQ>;
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
