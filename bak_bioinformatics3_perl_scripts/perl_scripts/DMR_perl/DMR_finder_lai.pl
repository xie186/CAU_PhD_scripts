#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==5;
my ($region,$forw,$rev,$out,$tissue)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die "$!";
open REGION,$region or die "$!";
while(<REGION>){
    chomp;
    my ($chr,$stt,$end)=split;
    my ($c_nu,$methlev)=(0,0);
        my $row=$dbh->prepare(qq(select * from $forw where chrom="$chr" and pos1>=$stt and pos1<=$end));
        $row->execute();
        my ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
         while($row->fetch()){
           $methlev+=$lev;
           $c_nu++;
        }
           $row=$dbh->prepare(qq(select * from $rev where chrom="$chr" and pos1>=$stt and pos1<=$end));
           $row->execute();
           ($chrm,$pos1,$pos2,$depth,$lev)=(0,0,0,0,0);
           $row->bind_columns(\$chrm,\$pos1,\$pos2,\$depth,\$lev);
         while($row->fetch()){
           $methlev+=$lev;
           $c_nu++;
        }
    next if $c_nu<(($end-$stt)/200)*5;
    $methlev=$methlev/$c_nu;
    print OUT "$_\t$c_nu\t$methlev\n";
}

sub usage{
    my $die=<<DIE;
    Usage:perl *.pl <Regions > <Forw> <Rev> <OUT1> <Tissue>
    OUTPUT:
    We use this to extract methylation level of a special region
DIE
}
