#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV == 3;
my ($fa, $bed, $context) = @ARGV;
open FA, $fa or die "$!";
my @fa = <FA>;
my $seq = join("", @fa);
   $seq =~ s/chr//g;
my $tot_c = $seq =~ tr/CG/CG/;
close FA;

my ($err_c, $err_tot) = (0,0);
my ($num_gt1, $num_gt2) = (0,0);
open BED,$bed or die "$!";
while(<BED>){
    chomp;
    my ($chr,$pos1,$pos2,$tot,$lev) = split;
    my $c_num = int( $tot*$lev/100 + 0.5);
    if(/chrchloroplast/){
        $err_c += $c_num;
        $err_tot += $tot;
    }
    if($tot >=1){
        $num_gt1 ++;
    }
    if($tot >=2){
        $num_gt2 ++;
    }
}
close BED;

print "$context\t$num_gt1\t$num_gt2\t$tot_c\t$err_c\t$err_tot\n";

sub usage{
    my $die =<<DIE;
    perl *.pl <FA> <bed> <context>
DIE
}
