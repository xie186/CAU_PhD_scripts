#!/usr/bin/perl -w
die "Usage:perl *.pl <GenePositionWork><ACGTcount>\nWe use this to profile methy through gene or TE(repeat)\n" unless @ARGV==2;
use strict;
my ($gene,$acgt)=@ARGV;
#set the key value
my %hash;
for(my $i=0;$i<150;++$i){
     $hash{$i}=[0,0,0];
}

my %acsh;my %gesh;                                   #i!!!!ATTENTIONS:Use this to judge whether the meth chomosome is consistent with the gene
foreach(my $j=1;$j<=20;++$j){
    my $nomen="chromosome"."0$j" if $j<10;
       $nomen="chromosome"."$j"if $j>=10;
       $acsh{$nomen}=$j;
}     
foreach(my $j=1;$j<=20;++$j){
    my $nomen="Chr"."$j";
    $gesh{$nomen}=$j;
}     
                                                
open GENE,$gene or die;
while(my $ge=<GENE>){
    my $find=index($ge,"gene",0);                     
    next if $find==-1;chomp $ge;                     
    my @gepos=(split(/\s+/,$ge))[0,3,4,6];            #    0,3,4,6 chromosome start end and strand respectively
    open ACGT,$acgt or die;
    while(my $ac=<ACGT>){
        chomp $ac;
        my ($methchr,$mepos,$conread,$lev)=(split(/\s+/,$ac))[0,1,3,4];
        my ($text,$read)=(split(/:/,$conread));
        my $judg_chr=$gesh{$gepos[0]}-$acsh{$methchr};
        
        if( $judg_chr!=0){
            next;
        }elsif($mepos>$gepos[1]-5000 && $mepos>$gepos[2]+5000 && $read>=10 ){
             &gene($gepos[1],$gepos[2],$mepos,$text,$lev);
        }else{
            next;
        }
    }
       
}

#print the table 
for(my $i=0;$i<150;++$i){ 
    print "${$hash{$i}}[0]\t${$hash{$i}}[1]\t${$hash{$i}}[2]\nHAHAHA!!";
}
#methy through gene body
sub  gene{
    my ($gestt,$geend,$mepos,$text,$lev)=@_;
    my $residue=($geend-$gestt)%50;
    my $divide=int ($geend-$gestt)/50;
    for(my $i=1;$i<=50;++$i){
       my $end;
       if($i==50){
            $end=$geend+$i*100+$residue;
       }else{
            $end=$geend+$i*100;
       }                                                         #  print "$mepos\t$end\t$geend\+\($i-1\)\*100\n";
       if($mepos<=$end && $mepos>=$geend+($i-1)*100){
           ${hash{$i+49}}[0]++ if $text eq "CG";
           ${hash{$i+49}}[0]++ if $text eq "CHG";
           ${hash{$i+49}}[0]++ if $text eq "CHH";
       }
    }
}

