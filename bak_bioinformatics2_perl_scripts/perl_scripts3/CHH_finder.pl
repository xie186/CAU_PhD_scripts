#!/usr/bin/perl -w
use strict;
my ($geno,$geno_len)=@ARGV;
die usage() unless @ARGV==2;
open GENO,$geno or die "$!";
my @aa=<GENO>;
my $join=join('',@aa);
$join=~s/>//;
   @aa=split(/>/,$join);
$join=@aa; #chromosome number
my %hash;
for(my $i=1;$i<=$join;++$i){
    my $tem=shift @aa;
    my ($chr,@seq)=split(/\n/,$tem);
    chomp @seq;
    my $tem_seq=join('',@seq);
    $hash{$chr}=$tem_seq;
}



foreach(sort{$a<=>$b}keys %hash_win){
    print "$_\t${$hash_win{$_}}[0]\t${$hash_win{$_}}[1]\n";
}

sub getseq{
    my ($chr,$stt,$end,$strand) = @_;
    if($strand eq "+"){
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $i*50+$stt;
            my $seq = substr($hash{$chr},$pos-100,$pos+100);
            print ">$stt\t$pos\t$i\n$seq\n";
            &chh($seq,$i);
        }
    }else{
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $end-$i*50;
            my $seq = substr($hash{$chr},$pos-100,$pos+100);
               $seq = reverse $seq;
               $seq =~ tr/ATGC/TACG/;
            &chh($seq,$i);
        }
    }
}

sub chh{
    my ($tem_seq,$tem_win) = @_;
    my $c = $tem_seq =~s/C/C/g;
    my $cg = $tem_seq =~ s/CG/CG/g;
    my $chg += $tem_seq =~ s/CAG/CAG/g;
       $chg += $tem_seq =~ s/CTG/CTG/g;
       $chg += $tem_seq =~ s/CCG/CCG/g;
    my $chh = $c-$cg-$chg;
    my $len = length $tem_seq;
    ${$hash_win{$tem_win}}[0] += $chh;
    ${$hash_win{$tem_win}}[1] += $len;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome seq> <Gene region>
DIE
}
