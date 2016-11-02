#!/usr/bin/perl -w
use strict;
use DBI;
die usage() unless @ARGV == 3;
my ($te_pos,$ge_pos,$out)=@ARGV;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=TE","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";

open OUT,"+>$out" or die "$!";
open POS,$ge_pos or die "$!";
while(<POS>){
    chomp;
    my ($chr,$stt,$end,$name,$strand)=split;
       $chr =~s/chr//;
    my $row=$dbh->prepare(qq(select * from $te_pos where \(chrom="$chr" and pos1<=$end+2000 and pos1>$stt-2000\) or \(chrom="$chr" and pos1<=$stt-2000 and pos2>=$stt-2000\)));
       $row->execute();
    my ($chrom,$tem_stt,$tem_end,$tem_strd,$type,$sub_type)=(0,0,0,0,0,0);
       $row->bind_columns(\$chrom,\$tem_stt,\$tem_end,\$tem_strd,\$type,\$sub_type);
    my $i=0;
    while($row->fetch()){
        print OUT "$_\t$chrom\t$tem_stt\t$tem_end\t$tem_strd\t$type\t$sub_type\n";
        $i++; 
    }
    if($i==0){
        print "$_\tNT\n";
    }else{
        print "$_\tTE\n";
    }
}
close OUT;
sub usage{
    my $die=<<DIE;
    perl *.pl <TE pos in TE databases [TE_pos]> <Gene position> <OUT>
DIE
}
