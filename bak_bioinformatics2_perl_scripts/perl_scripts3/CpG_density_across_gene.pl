#!/usr/bin/perl -w
use strict;
my ($geno,$gene,$out)=@ARGV;
die usage() unless @ARGV==3;
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

print "read Geno done!\n";
my %hash_win;
open GENE,$gene or die "$!";
while(<GENE>){
    chomp;
    next if !/^\d/; 
    my ($chr,$stt,$end,$gene_id,$strand)=(split);
        $chr = "chr$chr";
    &tss($chr,$stt,$end,$strand);
    &tts($chr,$stt,$end,$strand);
}

open OUT,"+>$out" or die "$!";
foreach(sort{$a<=>$b}keys %hash_win){
    print "$_\t${$hash_win{$_}}[0]\t${$hash_win{$_}}[1]\t${$hash_win{$_}}[2]\t${$hash_win{$_}}[3]\n";
}
close OUT;

sub tss{
    my ($chr,$stt,$end,$strand) = @_;
    if($strand eq "+"){
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $i*50+$stt;
            my $seq = substr($hash{$chr},$pos-100,200);
            &chh($seq,$i,"tss");
        }
    }else{
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $end-$i*50;
            my $seq = substr($hash{$chr},$pos-100,200);
               $seq = reverse $seq;
               $seq =~ tr/ATGC/TACG/;
            &chh($seq,$i,"tss");
        }
    }
}

sub tts{
    my ($chr,$stt,$end,$strand) = @_;
    if($strand eq "+"){
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $i*50+$end;
            my $seq = substr($hash{$chr},$pos-100,200);
            &chh($seq,$i,"tts");
        }
    }else{
        for(my $i = -40;$i <= 40;++$i){
            my $pos = $stt-$i*50;
            my $seq = substr($hash{$chr},$pos-100,200);
               $seq = reverse $seq;
               $seq =~ tr/ATGC/TACG/;
            &chh($seq,$i,"tts");
        }
    }
}


sub chh{
    my ($tem_seq,$tem_win,$tss_or) = @_;
    my $c = $tem_seq =~s/C/C/g;
    my $cg = $tem_seq =~ s/CG/CG/g;
    my $chg += $tem_seq =~ s/CAG/CAG/g;
       $chg += $tem_seq =~ s/CTG/CTG/g;
       $chg += $tem_seq =~ s/CCG/CCG/g;
    my $chh = $c-$cg-$chg;
    my $len = length $tem_seq;
    if($tss_or eq "tss"){
        ${$hash_win{$tem_win}}[0] += $chh;
        ${$hash_win{$tem_win}}[1] += $len;
    }else{
        ${$hash_win{$tem_win}}[2] += $chh;
        ${$hash_win{$tem_win}}[3] += $len;
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Genome seq> <Gene region> <OUT>
DIE
}
