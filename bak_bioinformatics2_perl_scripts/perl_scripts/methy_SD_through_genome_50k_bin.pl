#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==4;
my ($geno_chr,$forw,$rev,$out)=@ARGV;
die "$out exists!!!\n" if -e $out;

my ($context)=(split(/_/,$forw))[1];    ###`
open GENO,$geno_chr or die "$!";
my @tem=<GENO>;
my $chr=shift;
chomp @tem;
my $seq=join'',@tem;
my $len=length $seq;
   $seq="";

open METH,$forw or die "$!";
my %methy;
while(<METH>){ 
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<3;
#    next if $level<80;
    $methy{"$pos1.forw"}=$level;
}

open REV,$rev or die "$!";
while(<REV>){
    chomp;
    my ($chr,$pos1,$pos2,$depth,$level)=split;
    next if $depth<3;
#    next if $level<80;
    $methy{"$pos1.rev"}=$level;
}

my $num=int $len/50000;
print "$len\t$num\n";
open OUT,"+>$out" or die "$!";
for(my $i=0;$i<=$num;++$i){
     my ($methy_forw,$forw_nu,$methy_rev,$rev_nu,$forw_meth_nu,$rev_meth_nu)=(0,0,0,0);
     my @forw;my @rev;
    for(my $j=$i*50000;$j<=$i*50000+50000;++$j){
        if(exists $methy{"$j.forw"}){
             $methy_forw+=$methy{"$j.forw"};
             push @forw,$methy{"$j.forw"};
#             $forw_meth_nu++ if $methy{"$j.forw"}>=0.8;
#             $forw_nu++;
        }
        if(exists $methy{"$j.rev"}){
             $methy_rev+=$methy{"$j.rev"};
             push @rev,$methy{"$j.rev"};
#             $rev_meth_nu++ if $methy{"$j.rev"}>=0.8;
#             $rev_nu++;
        }
    }
    my $win_stt=$i*50000;
    my $for=join ",",@forw;
    my $rev=join ",",@rev;
    open R,"+>SD.R" or die "$!";
    print R "forw<-c($for)\nsd(forw)\nrev<-c($rev)\nsd(rev)";
    my $sd=`R --vanilla --slave <SD.R`;
    my ($forw_sd,$rev_sd)=$sd=~/\[1\]\s+(.*)\n\[1\]\s+(.*)\n/; 
#    my ($lev_forw,$lev_rev)=(0,0);
#    $lev_forw=$methy_forw/$forw_nu unless $forw_nu==0;
#    $lev_rev =$methy_rev/$rev_nu unless $rev_nu==0;
#    $lev_forw=$forw_meth_nu/$forw_nu unless $forw_nu==0;
#    $lev_rev =$rev_meth_nu/$rev_nu unless $rev_nu==0;
#    print OUT "$win_stt\t$lev_forw\t$lev_rev\t$lev_forw\t$lev_rev\n";
     print OUT "$win_stt\t$forw_sd\t$rev_sd\n"; 
     print "$win_stt\t$forw_sd\t$rev_sd\n";
    `rm SD.R`;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome> <Forwards_methy> <Reverse_methy> <OUT>
    <windows> <Forward> <Reverse>
DIE
}
