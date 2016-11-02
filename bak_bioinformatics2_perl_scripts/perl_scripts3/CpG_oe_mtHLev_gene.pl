#!/usr/bin/perl -w
use strict;
use DBI;
my ($tissue,$forw,$rev,$gene,$out)=@ARGV;
die usage() unless @ARGV==5;
my ($driver,$dsn,$usr,$pswd)=("mysql","database=$tissue","root","123456");
my $dbh=DBI->connect("dbi:$driver:$dsn",$usr,$pswd) or die "$DBI::errstr\n";
open GE,$gene or die "$!";
open OUT,"+>$out" or die "$!"; 
while(<GE>){
    chomp;
    my ($chr,$stt,$end,$name,$strand)=split;
    my ($meth_lev,$c_nu)=(0,0);
    foreach my $mth ($forw,$rev){
        my ($chrom,$tem_pos1,$tem_pos2,$depth,$lev)=(0,0,0,0,0);
        my $row=$dbh->prepare(qq(select * from $mth where chrom="chr$chr" and pos1>=$stt and pos1<=$end));
            $row->execute();
            $row->bind_columns(\$chrom,\$tem_pos1,\$tem_pos2,\$depth,\$lev);
        while($row->fetch()){
            $meth_lev+=$lev;
            $c_nu++;
        }
    }
    $meth_lev=$meth_lev/(0.000001+$c_nu);  #methycytocine propotion	
    print OUT "$_\t$c_nu\t$meth_lev\n";
}

sub usage{
    my $die=<<DIE;
    perl *.pl <Tissue> <Forward> <Reverse> <Gene> <OUTPUT>
DIE
}
