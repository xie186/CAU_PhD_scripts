#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==3;
my ($te,$tab,$chr_tem)=@ARGV;
open TE,$te or die "$!";
my ($driver,$db,$usr,$pswd)=("mysql","database=smRNA","root","123456");
my $dbh=DBI->connect("dbi:$driver:$db",$usr,$pswd) or die "$DBI::errstr";
while(<TE>){
    chomp;
    my ($chr,$stt,$end,$strand,$te_type1,$te_type2)=split;
    next if $chr==$chr_tem;
    my $tem=$dbh->prepare(qq(select * from $tab where chrom="chr$chr" and pos>=$stt and pos<=$end));
       $tem->execute();
    my ($id,$len,$copy,$strd,$chrom,$pos)=(0,0,0,0,0,0);
       $tem->bind_columns(\$id,\$len,\$copy,\$strd,\$chrom,\$pos);
    my $report=0;
    while($tem->fetch()){
       next if $len!=24;
       $report+=$copy;
    }
    if($report==0){
        print "$_\t0\n";
    }else{
        print "$_\t$report\n";
    }
}

sub usage{
    my $die=<<DIE;
    perl *.pl  <TE raw file> <smRNA table> <Chrom 1,2,3 etc.>
DIE
}

