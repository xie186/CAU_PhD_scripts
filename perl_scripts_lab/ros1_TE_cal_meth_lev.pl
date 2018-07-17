#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV ==2;
my ($eco_list, $meth) = @ARGV;

my @context = ("CpG", "CHG", "CHH", "CXX");
open LIST, $meth or die "$!";
my %meth_infor;
while(<LIST>){
    chomp; 
    #chr2    15314817        15314817        Aa_0    CHH     2       6
    my ($chr, $stt, $end, $eco, $class, $c_num, $tot) = split(/\s+/);
    #print "$chr, $stt, $end, $eco, $class, $c_num, $tot\n";
    ${$meth_infor{$eco} -> {$class}}[0] += $c_num;
    ${$meth_infor{$eco} -> {$class}}[1] += $tot;
    ${$meth_infor{$eco} -> {"CXX"}}[0] += $c_num;
    ${$meth_infor{$eco} -> {"CXX"}}[1] += $tot;
}
close LIST;

open ECO, $eco_list or die "$!";
while(my $eco = <ECO>){
    chomp $eco;
    next if $eco =~ /#/;
    my @lev;
    foreach my $context(@context){
        if (exists $meth_infor{$eco} && exists $meth_infor{$eco}-> {$context}){
            my $c_num   = ${$meth_infor{$eco}-> {$context}}[0];
            my $tot_num = ${$meth_infor{$eco}-> {$context}}[1];
            push @lev, $c_num/$tot_num;
        }else{
            push @lev, "NaN";
        }
    }
    my $lev = join("\t", @lev);
    print "$eco\t$lev\n";
}
close ECO;

sub usage{
    my $die =<<DIE;
perl $0 <eco_list> <meth>
DIE
}
