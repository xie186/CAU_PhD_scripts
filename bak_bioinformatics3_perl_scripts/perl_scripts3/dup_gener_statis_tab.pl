#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==1;
my ($rpkm)=@ARGV;
open RPKM,$rpkm or die "$!";
my @fc2;my @fc4;my @fc0;
while(<RPKM>){
    chomp;
    my ($id,$id2,$gene1,$rpkm1,$gene2,$rpkm2)=split;
    if($rpkm1/($rpkm2+0.0000001)>=2 && $rpkm1>=1){
        $fc2[0]++;
    }elsif($rpkm2/($rpkm1+0.0000001)>=2 && $rpkm2>=1){
        $fc2[1]++;
    }
   
    if($rpkm1/($rpkm2+0.0000001)>=4 && $rpkm1>=1){
        $fc4[0]++;
    }elsif($rpkm2/($rpkm1+0.0000001)>=4 && $rpkm2>=1){
        $fc4[1]++;
    }
   
   if($rpkm1>=1 && $rpkm2==0){
        $fc0[0]++;
   }elsif($rpkm2>=1 && $rpkm1==0){
        $fc0[1]++;
    }
    
}

print "FC\tSub1 Dominant\tSub2 Dominant\n";
print "2FC\t$fc2[0]\t$fc2[1]\n";
print "4FC\t$fc4[0]\t$fc4[1]\n";
print "0FC\t$fc0[0]\t$fc0[1]\n";


sub usage{
    my $die=<<DIE;
    perl *.pl <Dup RPKM>
DIE
}
