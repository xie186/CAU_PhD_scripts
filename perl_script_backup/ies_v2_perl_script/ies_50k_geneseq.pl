#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($gene,$geno_pwd,$out)=@ARGV;
open OUT,"+>$out" or die "$!";
open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    my ($chr,$stt,$end,$name,$ies)=(split)[0,1,2,3,-1];
       next if $chr eq 'UNKNOWN';
    print "$chr,$stt,$end,$name,$ies\n$geno_pwd\/chr$chr.fa\n"; 
    open GENO,"$geno_pwd\/chr$chr.fa" or die "$!";
    my @geno=<GENO>;
    my $geno_chr=shift @geno;
    chomp @geno;
    my $seq=join'',@geno;
   
    my $tem_seq=substr($seq,$stt-1,$end-$stt+1);
    print OUT ">$name\n$tem_seq\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Gene name> <Genome PWD> <OUT>
DIE
}
