#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 4;
my ($sam,$read,$out1,$out2) = @ARGV;
open SAM,$sam or die "$!";
my %read_id;
while(<SAM>){
    chomp;
    next if /^@/;
    my ($id,$seq,$qual) = (split)[0,9,10];
    my $tem_id = $id;
    if($id =~/\/1/){
        $id =~ s/\/1/\/2/;
    }else{
        $id =~ s/\/2/\/1/;
    }
    $id = "@".$id;
    $read_id{$id} = "\@$tem_id\n$seq\n+\n$qual\n";
}

open READ,$read or die "$!";
open OUT1, "+>$out1" or die "$!";
open OUT2, "+>$out2" or die "$!";
while( my $id = <READ>){
    chomp $id;
    my $seq  = <READ>;
    my $third = <READ>;
    my $qual = <READ>;
    next if !exists $read_id{$id};

    print OUT1 "$id\n$seq"."$third"."$qual";
    print OUT2 "$read_id{$id}";
}

sub usage{
    my $die =<<DIE;
    perl *.pl <sam file> <read file>  <OUT1> <OUT2>
DIE
}
