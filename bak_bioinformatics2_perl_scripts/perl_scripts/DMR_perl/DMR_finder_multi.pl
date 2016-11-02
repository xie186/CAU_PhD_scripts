#!/usr/bin/perl -w
use strict;
use DBI;
die usage() if @ARGV==0;
my ($geno_len,$forw,$rev,$out,@tissue)=@ARGV;
my @dbh;my $i=0;
foreach(@tissue){
    my ($driver,$dsn,$usr,$pswd)=("mysql","database=$_","root","123456");
    $dbh[$i]=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
    ++$i;
}
my ($chrom_rcode)=$geno_len=~/(chr\d+)/;
open LEN,$geno_len or die "$!";
my %hash;
while(<LEN>){
    chomp;
    my ($chr,$len)=split;
    $hash{$chr}=$len;
}

open OUT,"+>$out" or die "$!";
foreach my $chrom(keys %hash){
    for(my $i=1;$i<=$hash{$chrom}/20-1;++$i){
        my ($stt,$end)=(($i-1)*20,($i-1)*20+200-1);
        my @print;
        for(my $j=0;$j<@dbh;++$j){
             my ($c_nu,$methlev1)=&get($chrom,$stt,$end,$dbh[$j]);
             push @print,($c_nu,$methlev1);
        }
        my $print=join("\t",@print);
        print OUT "$chrom\t$stt\t$end\t$print\n";
    }
}

sub get{
    my ($chrom,$stt,$end,$dbh)=@_;
    my ($methlev,$c_nu)=(0,0);
    foreach ($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $methlev+=$lev;
           $c_nu++;
        }
    }
    $methlev=$methlev/($c_nu+0.00001);
    return ($c_nu,$methlev);
}

sub usage{
    my $die=<<DIE;

    Usage:perl *.pl <Geno_len> <Forw> <Rev> <OUT1> <Tissue INT>
    OUTPUT:
    <Chrom> <STT> <END> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev> <T2_meth_nu> <T2_unmeth_nu> <T2_methlev> <Fiser P-value>

DIE
}
