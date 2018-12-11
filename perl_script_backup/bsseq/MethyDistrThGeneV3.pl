#!/usr/bin/perl -w
my $die=<<USAGE;
Usage:perl *.pl <GenePositionWork><ACGTcount>.
We use this to profile methy through gene or TE(repeat) in 100 bp bin.
USAGE

die "$die" unless @ARGV==2;
use strict;
my ($gene,$acgt)=@ARGV;
#set the key value
my %hash;
for(my $i=0;$i<70;++$i){
     $hash{$i}=[0,0,0];
}

my %acsh;my %gesh;                                #i!!!!ATTENTIONS:Use this to judge whether the meth chomosome is consistent with the gene
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
        }elsif($mepos>$gepos[1]-1000 && $mepos<$gepos[2]+1000 && $read>=5 && $lev>0){
            &distri($gepos[1],$gepos[2],$mepos,$text,$lev,$gepos[3]);
        }else{
            next;
        }
    }       
}
close GENE;
close ACGT;

#print the table 
print "position\tCG\tCHG\tCHH\t2010:12:19\n";
for(my $i=0;$i<70;++$i){
    my $j=$i+1; 
    print "$j\t${$hash{$i}}[0]\t${$hash{$i}}[1]\t${$hash{$i}}[2]\n";
}
#methy through gene body
sub  distri{
    my ($gestt,$geend,$mepos,$text,$lev,$strand)=@_;
    my $residue=($geend-$gestt)%50;
    my $divide=int ($geend-$gestt)/50;
    if($strand eq "+"){
        for(my $i=0;$i<150;++$i){
           my $end;
           if($i==59){
                $end=$gestt-1000+$i*100+$residue;
           }else{
                $end=$gestt-1000+$i*100;
           }                                                         #  print "$mepos\t$end\t$geend\+\($i-1\)\*100\n";
           if($mepos>=$gestt-1000+$i*100 && $mepos<=$gestt-1000+($i+1)*100){
               ${hash{$i}}[0]++ if $text eq "CG";
               ${hash{$i}}[1]++ if $text eq "CHG";
               ${hash{$i}}[2]++ if $text eq "CHH";
           }
        }
   }else{
        for(my $i=69;$i>=0;--$i){
            my $end;
            if($i==59){
                $end=$geend+1000-(69-$i)*100+$residue;
            }else{
                $end=$geend+1000-(69-$i)*100;
            }
            if($mepos>=$end+1000-(70-$i)*100 && $mepos<=$end+1000-(69-$i)*100){
                ${hash{$i}}[0]++ if $text eq "CG";
                ${hash{$i}}[1]++ if $text eq "CHG";
                ${hash{$i}}[2]++ if $text eq "CHH";
            }
        }
   }
}
