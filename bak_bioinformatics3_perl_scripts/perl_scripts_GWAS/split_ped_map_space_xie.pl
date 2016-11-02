#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($map,$ped) = @ARGV;
open MAP, $map or die "$!";
my @map=<MAP>;
close MAP;

my $num = @map;
my $num_part = $num/5000;

for(my $i=0;$i<$num_part;$i++){
    my $tem_map = $map;
       $tem_map =~ s/\.map/\_$i.map/g;
    open R1, "+>$tem_map";
    if($i<$num_part-1){
        for(my $j=$i*5000;$j<($i+1)*5000;$j++){
            print R1 "$map[$j]";
        }
     }else{
         for(my $j=$i*5000;$j<$num;$j++){
             print R1 "$map[$j]";
         }
     }
     close R1;
}

open PED, $ped or die "$!";
while (<PED>){
    my @fen=split(/\t/,$_);
    my $n=@fen;
    my $num=($n-6)/5000;
    for(my $i=0;$i<$num;$i++) { ####not the last one
        my $tem_ped = $ped;
           $tem_ped =~ s/\.ped/\_$i.ped/g;
        open E, "+>>$tem_ped" or die "$!";
        print E "$fen[0]\t$fen[1]\t$fen[2]\t$fen[3]\t$fen[4]\t$fen[5]\t";

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
