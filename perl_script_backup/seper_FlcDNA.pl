#!/usr/bin/perl -w

die "perl *.pl <PSL><FASTA_seq><OUT_flc><NoFlc>" unless @ARGV==4;
use strict;
open BLATPLS,$ARGV[0] or die;

my $line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;

my %hash;
while(my $psl=<BLATPLS>){
    chomp $psl;
    my ($name,$length,$cdna)=(split(/\s+/,$psl))[9,10,13];
#    print "$match\t$length\n";
#    my $coverage=$match/$length;
#    print "$coverage\t"; 
#    if($coverage>=0.7){
        $hash{$name}.=$cdna."\t";
#    }else{
    
#    }    
}

#foreach(keys %hash){
#    print "$_\t$hash{$_}\n";
#}
open FA,$ARGV[1] or die;
open FLC,"+>$ARGV[2]" or die;
open NOF,"+>$ARGV[3]" or die;
while(my $nm=<FA>){
    chomp $nm;
    $nm=~s/>//;
    my $seq=<FA>;
    if(exists $hash{$nm}){
        print FLC ">$nm\n$seq";
    }else{
        print NOF ">$nm\n$seq";
    }
}
