#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==7;
my ($ibd_region,$forw,$rev,$tissue1,$win,$step,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue1","root","123456");
my $dbh1=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open IBD,$ibd_region or die "$!";
my %hash;
while(<IBD>){
    chomp;
    my ($chr,$stt,$end)=split;
    $stt = $stt * 1000000;
    $end = $end * 1000000;
    $hash{"$chr\t$stt\t$end"}=0;
}

open OUT,"+>$out" or die "$!";
foreach my $region(keys %hash){
#    next if $chrom ne $chrom_sta;
    my ($ibd_chr,$ibd_stt,$ibd_end) = split(/\t/,$region);
    for(my $i = $ibd_stt;$i <= $ibd_end ; $i += $step){
        my ($stt,$end)=($i,$i + $win);
        my ($meth1,$unmeth1,$methlev1,$c_nu)=&get($ibd_chr,$stt,$end,$dbh1);
        print OUT "$ibd_chr\t$stt\t$end\t$c_nu\t$meth1\t$unmeth1\t$methlev1\n";
    }
}

sub get{
    my ($chrom,$stt,$end,$dbh)=@_;
    my ($meth,$unmeth,$methlev,$c_nu)=(0,0,0,0);
    foreach ($forw,$rev){
        my $row=$dbh->prepare(qq(select * from $_ where chrom="$chrom" and pos1>=$stt and pos1<=$end));
           $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
        while($row->fetch()){
           $methlev+=$lev;
           $c_nu++;
           $meth   += (int ($depth*$lev+0.5))/100;
           $unmeth += $depth-(int ($depth*$lev+0.5))/100;
        }
    }
    $methlev=$methlev/($c_nu+0.0000001);
    return ($meth,$unmeth,$methlev,$c_nu);
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <IBD_region> <Forw> <Rev> <Tissue1> <Windows size > <Step size> <OUT>
    OUTPUT:
    <Chrom> <STT> <END> <C number> <T1_meth_nu> <T1-unmeth_nu> <T1_methlev>
DIE
}
