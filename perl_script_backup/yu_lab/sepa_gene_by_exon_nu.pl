#!/usr/bin/perl -w
use strict;

my ($gff,$dof,$one,$gt)=@ARGV;
die usage() unless @ARGV==4;
open DOF,$dof or die "$!";
open GFF,$gff or die "$!";

open OUT1,"+>$one";
open OUT2,"+>$gt";
while(my $name=<DOF>){
    my $seq=<DOF>;
    chomp $name;
    $name=~s/>//;
    my $cds=0;
    while(my $anno=<GFF>){
        chomp $anno;
        if((my $find=index($anno,$name,0))>-1){
            my ($ele)=(split(/\s+/,$anno))[2];
            $cds++ if $ele eq "exon";
        }
    }
    if($cds==1){
        print OUT1 ">$name\n$seq";
    }elsif($cds>1){
        print OUT2 ">$name\n$seq";
    }else{
        print ">$name\n$seq";
    }
}

sub usage{
    my $die=<<DIE;
perl *.pl <Gene GFF> <Dof>  <one> <Gt one>
DIE
}
