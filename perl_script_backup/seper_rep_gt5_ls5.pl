#!/usr/bin/perl -w
use strict;
die "perl *.pl <PSL><Nr_.fa><Repetitice gt5><Less 5>\n" unless @ARGV==4;
open BLATPLS,$ARGV[0] or die;
my $line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;
$line=<BLATPLS>;

my %hash;
while(my $psl=<BLATPLS>){
    chomp $psl;
    my ($match,$name,$length)=(split(/\s+/,$psl))[0,9,10];
#    print "$match\t$length\n";
    my $coverage=$match/$length;
#    print "$coverage\t"; 
    ($name)=split(/\|/,$name);
    if($coverage>=0.7){
        $hash{$name}++;
    }else{
        next;
    }    
}

foreach(keys %hash){
    print "$_\t$hash{$_}\n";
}
open FA,$ARGV[1] or die;
open REP,"+>$ARGV[2]" or die;
open LES,"+>$ARGV[3]" or die;
while(my $nm=<FA>){
    chomp $nm;
    $nm=~s/>//;
    ($nm)=split(/\|/,$nm);
    my $seq=<FA>;
    if(exists $hash{$nm} && $hash{$nm}>=5){
        print REP "$nm\n";
    }else{
        print LES ">$nm\n$seq";
    }
}
