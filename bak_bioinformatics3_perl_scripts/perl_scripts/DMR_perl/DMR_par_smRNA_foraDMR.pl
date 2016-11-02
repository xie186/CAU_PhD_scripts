#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==4;
my ($map_loca,$db,$tab,$admr)=@ARGV;
my ($driver,$dab,$usr,$pswd)=("mysql","database=$db","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dab",$usr,$pswd) or die "$DBI::errstr";

open MAP,$map_loca or die "$!";
my %hash_loca;
while(<MAP>){
    chomp;
    my ($id,$len,$copy,$map_loca)=split;
    $hash_loca{$id}=$map_loca;
}

my $len=0;
open ADMR,$admr or die "$!";
my %hash_nu;
my %hash_len;
while(<ADMR>){
    chomp;
    my ($chr,$stt,$end)=split;
    $len+=$end-$stt+1;
    my $tem=$dbh->prepare(qq(select * from $tab where chrom="$chr" and pos>=$stt-31 and pos<=$end+31));
       $tem->execute();
    my ($id,$len,$copy,$strd,$chrom,$pos)=(0,0,0,0,0,0);
       $tem->bind_columns(\$id,\$len,\$copy,\$strd,\$chrom,\$pos);
    my $smrna=0;
    while($tem->fetch()){
        $hash_nu{$len}+=$copy/$hash_loca{$id};
    }
}

foreach(sort{$a<=>$b}keys %hash_nu){
    my $nu=$hash_nu{$_}*1000000/$len;
    print "$_\t$nu\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <map location> <database [smRNA]>  <table> <aDMR> 
DIE
}
