#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($map,$ped,$del_ratio,$out_map,$out_ped) = @ARGV;
open MAP, $map or die "$!";
my @map=<MAP>;
close MAP;
my $num = @map;
my $rand_time = int ($del_ratio * $num);

my %hash;
for(my $i =1;$i <= $rand_time; ++$i){
    my $rand = int (rand($num)) + 1;
    $hash{$rand} ++;
}

open OUT1,"+>$out_map" or die "$!";
for(my $i=1;$i <= $num; $i++){
    next if exists $hash{$i};
    print OUT1 $_;
}

open PED, $ped or die "$!";
open OUT2, "$out_ped" or die "$!";
while (<PED>){
    my @fen=split(/\t/,$_);
    my $n=@fen;
    print OUT2 "$fen[0]\t$fen[1]\t$fen[2]\t$fen[3]\t$fen[4]\t$fen[5]\t";
    for(my $i = 6;$i < $n; $i += 2){
        
    }
        if($i < ($num-1)){
            for(my $j=6+$i*5000;$j<($i+1)*5000+6;$j++){
                print E "$fen[$j]\t";
            }
            print E "\n";
        }else{
            for(my $j=6+$i*5000;$j<$n;$j++){
                print E "$fen[$j]\t";
            }
            print E "\n";
        }
        close E;
   }   
}

sub usage{
    print <<DIE;
    perl *.pl <MAP file> <PED file>
DIE
    exit 1;
}
