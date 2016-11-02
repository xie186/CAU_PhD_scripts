#!/usr/bin/perl -w
use strict;
die usage() unless @ARGV==3;
my ($cg,$chg,$chh,$tol)=@ARGV;
open CG,"sort -u $cg|" or die "$!";
my %hash;
while(<CG>){
    chomp;
    my ($chr,$stt,$end,$strand,$id_mat,$id_off,$c_cov,$methy_lev,$c_nu)=split("\t",$_);
    next if ($c_cov<5 || $c_cov/($c_nu+0.0000001)<0.3);
    @{$hash{"$chr\t$stt\t$end\t$id_mat\t$id_off"}}=($c_cov,$methy_lev);
}

open CHG,"sort -u $chg|" or die "$!";
while(<CHG>){
    chomp;
    my ($chr,$stt,$end,$strand,$id_mat,$id_off,$c_cov,$methy_lev,$c_nu)=split("\t",$_);
    next if ($c_cov<5 || $c_cov/($c_nu+0.0000001)<0.3);
    push @{$hash{"$chr\t$stt\t$end\t$id_mat\t$id_off"}},($c_cov,$methy_lev);
}

open CHH,"sort -u $chh |" or die "$!";
while(<CHH>){
    chomp;
    my ($chr,$stt,$end,$strand,$id_mat,$id_off,$c_cov,$methy_lev,$c_nu)=split("\t",$_);
    next if ($c_cov<5 || $c_cov/($c_nu+0.0000001)<0.3);
    push @{$hash{"$chr\t$stt\t$end\t$id_mat\t$id_off"}},($c_cov,$methy_lev);
}

foreach(keys %hash){
    my $value=join("\t",@{$hash{$_}});
    print "$_\t$value\n" if @{$hash{$_}}==6;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Seedlings> <Embryo> <Endosperm>
DIE
}
