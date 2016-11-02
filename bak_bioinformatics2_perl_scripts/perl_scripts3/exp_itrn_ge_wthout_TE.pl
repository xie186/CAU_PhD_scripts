#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV==2;
my ($te_pos,$ge_pos)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=TE","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$name,$strand)=split;
    my $row=$dbh->prepare(qq(select * from $te_pos where \(chrom="$chr" and pos1<=$end and pos1>$stt\) or \(chrom="$chr" and pos1<=$stt and pos2>=$stt\)));
       $row->execute();
    my ($chrom,$tem_stt,$tem_end,$tem_strd,$type,$sub_type)=(0,0,0,0,0,0);
       $row->bind_columns(\$chrom,\$tem_stt,\$tem_end,\$tem_strd,\$type,\$sub_type);
    my $i=0;
    while($row->fetch()){
        $i++; 
    }
    print "$_\tNT\n" if $i==0;
}

sub usage{
    my $die=<<DIE;
    perl *.pl <TE pos in TE databases [TE_pos]> <Gene position>
DIE
}
