#!/usr/bin/perl -w
use strict;

die usage() unless @ARGV==4;
my ($clas4,$rpkm,$out1,$out2)=@ARGV;
open RPKM,$rpkm or die "$!";
my %hash;
while(<RPKM>){
    chomp;
    my ($gene,$rpkm)=(split)[0,-1];
    $hash{$gene}=$rpkm;
}

open POS,$clas4 or die "$!";
open OUT1,"+>$out1";
open OUT2,"+>$out2";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$gene,$strand,$type,$cpg_oe,$te_or)=(split)[0,1,2,3,4,5,11,13];
    print "$chr,$stt,$end,$gene,$strand,$type,$cpg_oe,$te_or\n";
    next if $te_or =~ /TE/;
    my $tem_rpkm=0;
       $tem_rpkm=$hash{$gene} if exists $hash{$gene};
    if($cpg_oe <= 0.8){
        print OUT1 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$cpg_oe\t$tem_rpkm\n";
    }else{
        print OUT2 "$chr\t$stt\t$end\t$gene\t$strand\t$type\t$cpg_oe\t$tem_rpkm\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Class4> <rpkm> <out LC> <out HC>
DIE
}
